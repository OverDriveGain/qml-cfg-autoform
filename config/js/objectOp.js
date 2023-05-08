function set(obj, path, value) {
    let schema = obj
    const pList = path.split('.')
    const len = pList.length
    for (var i = 0; i < len - 1; i++) {
        const elem = pList[i]
        if (!schema[elem])
            schema[elem] = {}
        schema = schema[elem]
    }
    schema[pList[len - 1]] = value
}

function get(obj, path) {
    let schema = obj
    const pList = path.split('.')
    const len = pList.length
    for (var i = 0; i < len - 1; i++) {
        const elem = pList[i]
        if (!schema[elem])
            schema[elem] = {}
        schema = schema[elem]
    }

    return schema[pList[len - 1]]
}