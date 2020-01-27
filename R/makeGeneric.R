.makeGeneric = function(methods, type, assignEnvir){
  apply(methods, 1, function(x) {
    if(!x[[4]]) {
      if(type == "S3"){
        value = function(object,...){}
        body(value) = substitute({
          UseMethod(y, object)
        },list(y=x[[1]]))

        assign(x = x[[1]],
               value = value,
               envir = assignEnvir)
      } else if(type == "S4"){
        methods::setGeneric(x[[1]],
                            def = function(object, ...){},
                            where = assignEnvir)
      }
    }
  })
}
