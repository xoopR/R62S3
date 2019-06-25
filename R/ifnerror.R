ifnerror <- function(expr, noerror, error = NULL, silent = T){
  x = try(expr, silent)
  if(inherits(x, "try-error")){
    if(is.null(error) | error == "warn")
      stopwarn("warn", "Error not Nerror!")
    else if(error == "stop")
      stopwarn("stop", "Error not Nerror!")
    else
      error
  } else {
    noerror
  }
}
