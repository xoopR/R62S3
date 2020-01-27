.getBody = function(methods){
  body = apply(methods, 1, function(amethod) {
    if(amethod[3] == "public") {
      list(substitute({
        args = as.list(match.call())
        args[[1]] = NULL
        args$object = NULL
        do.call(get(object)[[method]], args)
      },list(method=amethod[[1]], object = amethod[[5]])))
    } else {
      list(substitute({
        args = as.list(match.call())
        args[[1]] = NULL
        args$object = NULL
        get(object)[[method]]
      },list(method=amethod[[1]], object = amethod[[5]])))
    }
  })

  cbind(methods, data.table::data.table(body))
}
