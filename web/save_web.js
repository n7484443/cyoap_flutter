function _exportRaw(name, data) {
    let urlObject = window.URL || window.webkitURL || window;
    let export_blob = new Blob([data]);
    let save_link = document.createElementNS("http://www.w3.org/1999/xhtml", "a");
    save_link.href = urlObject.createObjectURL(export_blob);
    save_link.download = name;
    save_link.click();
}

function _compressToZip(nameDataMap){
    let zip = new JSZip();
    let obj = JSON.parse(nameDataMap);
    for(const key in obj){
        if(key.startsWith("images")){
            let data = obj[key];
            zip.file(key, data);
        }else{
            zip.file(key, obj[key]);
        }
    }
    return zip.generateAsync({
        type:"uint8array",
        compression: "DEFLATE",
        compressionOptions: {
            level: 1
        }}).then(
        function (output) {
            return output;
        }
    );
}