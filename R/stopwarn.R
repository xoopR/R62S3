stopwarn <- function(error = "warn", error.msg){
  checkmate::assert(error == "warn", error == "stop",
                    .var.name = "'error' should be one of 'warn' or 'stop'.")
  if(error == "stop")
    stop(error.msg)
  else{
    warning(error.msg, call. = F)
    return(NULL)
  }
}
