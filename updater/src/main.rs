use std::{fs, io};
use std::io::Cursor;
use std::path::PathBuf;
use octocrab::models::repos::{Asset};

#[tokio::main]
async fn main() {
    let download_path = download().await;
    unzip(download_path.clone()).await;
    delete_zip(download_path).await;
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
        let outpath = match file.enclosed_name(){
            Some(p) => p.to_owned(),
            None => continue,
        };
        if file.name().ends_with('/'){
            match fs::create_dir_all(&outpath){
                Ok(_) => {},
                Err(e) => {
                    println!("Error: {}", e);
                }
            };
        }else{
            if file.name().ends_with("updater.exe"){
                continue;
            }
            let mut outfile = fs::File::create(&outpath).unwrap();
            io::copy(&mut file, &mut outfile).unwrap();
        }
    }
}

async fn delete_zip(path:PathBuf){
    fs::remove_file(path).unwrap();
}