.assignMethods <- function(methods, type, assignEnvir, dispatch_names, mask = FALSE){
  apply(methods, 1, function(amethod){
    if(type == "fun" & mask | type == "fun" & !amethod[[4]])
      method = amethod[[1]]
    else
      method = paste(amethod[[1]], dispatch_names, sep=".")

    value = function(){}
    x = alist(x=)
    names(x) = amethod[[5]]
    formals(value) = c(x,formals(amethod[[2]]))
    body(value) = amethod[[6]][[1]]
    if(type %in% c("S3", "fun"))
      sapply(method, function(x) assign(paste0(x), value, envir = assignEnvir))
    else if(type == "S4")
      sapply(dispatch_names, function(x){
        methods::setOldClass(x, where = assignEnvir)
        methods::setMethod(amethod[[1]], x, def = value, where = assignEnvir)
      })
  })

}
