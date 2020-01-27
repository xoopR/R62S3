.detectGeneric <- function(methods, type = c("S3", "S4"), mask = FALSE, arg1){

  generic = apply(methods, 1, function(amethod){
    methodname = amethod[[1]]
    generic = FALSE

    if(!mask){
      if("S3" %in% type) {
        x = try(utils::isS3stdGeneric(methodname), silent = TRUE)
        if(x == TRUE) {
            return(list(generic = TRUE, arg1 = names(formals(args(get(methodname)))[1])))
        }
      }

      if("S4" %in% type) {
        if(length(methods::.S4methods(methodname)) > 0) {
          return(list(generic = TRUE, arg1 = names(formals(args(get(methodname)))[1])))
        }
      }
    }

    return(list(generic = FALSE, arg1 = arg1))
  })

  cbind(data.table::data.table(methods), data.table::rbindlist(generic))
}
