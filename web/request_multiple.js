async function _readFileFromAjax(path){
    return await ((await fetch(path)).arrayBuffer());
}

async function _readFileFromAjaxWithJson(path){
    return await ((await fetch(path)).text());
}