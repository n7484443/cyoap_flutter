use std::{fs, io};
use std::fs::remove_file;
use std::io::Cursor;
use std::path::{Path, PathBuf};
use octocrab::models::repos::{Asset};

#[tokio::main]
async fn main() {
    println!("check version...");
    let download_path = download().await;
    unzip(download_path.clone()).await;
    delete_zip(download_path).await;
    println!("update complete");

}

async fn download() -> PathBuf{
    let release = octocrab::instance()
        .repos("n7484443", "cyoap_flutter")
        .releases()
        .get_latest()
        .await.unwrap();
    let search:Vec<&Asset> = release.assets.iter().filter(|asset| asset.name.contains("windows")).collect();
    let file = *search.first().unwrap();
    let file = file.clone().browser_download_url;
    let current_dic = std::env::current_dir().unwrap();
    let current_path = current_dic.as_path().clone();
    let file_path = current_path.join("update.zip");
    println!("Latest release: {} {} , install as {:?}", release.tag_name, file, current_dic);

    let response = reqwest::get(file).await.unwrap();
    let mut file = fs::File::create(file_path.clone()).unwrap();
    let mut content = Cursor::new(response.bytes().await.unwrap());
    std::io::copy(&mut content, &mut file).unwrap();

    return file_path;
}

async fn unzip(path:PathBuf){
    let file = fs::File::open(path).unwrap();
    let mut archive = zip::ZipArchive::new(file).unwrap();

    for i in 0..archive.len(){
        let mut file = archive.by_index(i).unwrap();
        let out_path = match file.enclosed_name(){
            Some(p) => p.to_owned(),
            None => continue,
        };
        if file.name().ends_with('/'){
            match fs::create_dir_all(&out_path){
                Ok(_) => {},
                Err(e) => {
                    println!("Error: {}", e);
                }
            };
        }else{
            let path = if file.name().ends_with("updater.exe"){
                Path::new("updater_tmp.exe")
            }else{
                &out_path
            };
            let mut outfile = fs::File::create(path).unwrap();
            io::copy(&mut file, &mut outfile).unwrap();
        }
    }
}

async fn delete_zip(path:PathBuf){
    remove_file(path).unwrap();
    self_replace::self_replace("updater_tmp.exe").unwrap();
    remove_file("updater_tmp.exe").unwrap();
}