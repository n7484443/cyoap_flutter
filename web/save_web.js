function _exportRaw(name, data) {
    var urlObject = window.URL || window.webkitURL || window;
    var export_blob = new Blob([data]);
    var save_link = document.createElementNS("http://www.w3.org/1999/xhtml", "a");
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
            let output = [];
            for(let i = 0; i < data.length; i++){
                output[i] = data.charCodeAt(i);
            }
            zip.file(key, output);
        }else{
            zip.file(key, obj[key]);
        }
    }
    return zip.generateAsync({type:"uint8array"}).then(
        function (output) {
            return output;
        }
    );
}