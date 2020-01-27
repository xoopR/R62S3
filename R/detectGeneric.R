.detectGeneric <- function(methods, type = c("S3", "S4"), mask = FALSE, arg1){

  generic = apply(methods, 1, function(amethod){
    methodname = amethod[[1]]
    generic = FALSE

    if(!mask){
      if(("S3" %in% type & utils::isS3stdGeneric(methodname)) |
         ("S4" %in% type & length(methods::.S4methods(methodname)) > 0)){
          return(list(generic = TRUE, arg1 = names(formals(args(get(methodname)))[1])))
      }
    }

    # return(list(generic = FALSE, arg1 = arg1))
    #
    # if("S3" %in% type) {
    #   if(mask){
    #     x = tryCatch(methods(methodname),warning = function(w) w, error = function(e) e)
    #     if(inherits(x, "condition")){
    #       if(!grepl("appears not to be S3 generic",x$message) & !inherits(x, "error"))
    #         return(list(generic = TRUE, arg1 = names(formals(get(methodname))[1])))
    #     } else if(length(x)!=0)
    #       return(list(generic = TRUE, arg1 = names(formals(get(methodname))[1])))
    #   } else{
    #     x = suppressWarnings(suppressMessages((try(methods(methodname),silent=T))))
    #     y = suppressWarnings(suppressMessages((try(get(methodname),silent=T))))
    #     if(class(x)!="try-error" | class(y)!="try-error"){
    #       if(length(x) > 0 | length(y) > 0)
    #         return(list(generic = TRUE, arg1 = names(formals(get(methodname))[1])))
    #     }
    #   }
    # }
    #
    # if("S4" %in% type) {
    #   if(mask){
    #     x = tryCatch(methods(methodname),warning = function(w) w, error = function(e) e)
    #     if(inherits(x, "condition")){
    #       if(!grepl("appears not to be S3 generic",x$message) & !inherits(x, "error"))
    #         return(list(generic = TRUE, arg1 = names(formals(get(methodname))[1])))
    #     } else
    #       return(list(generic = TRUE, arg1 = names(formals(get(methodname))[1])))
    #   } else{
    #     x = suppressWarnings(suppressMessages((try(methods(methodname),silent=T))))
    #     if(class(x)!="try-error"){
    #       if(length(x) > 0)
    #         return(list(generic = TRUE, arg1 = names(formals(get(methodname))[1])))
    #     }
    #   }
    # }
    #
    return(list(generic = FALSE, arg = arg1))
  })

  cbind(data.table::data.table(methods), data.table::rbindlist(generic))
}
