#-------------------------------------------------------------------------------
#
# Helper function to automatially generate S3 methods from a defined
#   R6 class. Where required, S3 generics are defined.
#
# author: raphael.sonabend.15@ucl.ac.uk
#
#-------------------------------------------------------------------------------
R62S3 <- function(R6Class, envir = .GlobalEnv){
  #' S3 Method Generator from R6 Class
  #'
  #' @description Auto-generates S3 generics and public methods from an R6 Class.
  #' @param R6Class The R6ClassGenerator or Classname to generate public methods from
  #' @param envir The enviornment to assign the methods to. Global environment by default.
  #' @usage R62S3(R6Class)
  #' @return Assigns methods and generics to the chosen environment.
  #' @details The input must either be of class R6ClassGenerator or a character
  #' string naming the R6ClassGenerator. Also assumes the classname is the same
  #' as the R6ClassGenerator name.
  #' @examples
  #' Queue <- R6Class(...)
  #' q <- Queue$new(5,6,"foo")
  #' R62S3("Queue")
  #' R62S3(Queue)

  assert(inherits(R6Class,"character"),inherits(R6Class,"R6ClassGenerator"),
         .var.name = "R6Class must either be an R6ClassGenerator or a
         character string naming a generator.")
  if(testCharacter(R6Class))
    obj = get0(R6Class, envir = .GlobalEnv)
  else
    obj = R6Class
  methods = obj$public_methods[!(names(obj$public_methods) %in% c("initialize","clone"))]
  for(i in 1:length(methods)){
    getter = get0(names(methods)[[i]])
    x = FALSE
    generic = FALSE
    if(!is.null(getter)){
      x = suppressAll(try(methods(getter),silent=T))
      if(class(x)!="try-error"){
        x = suppressAll(methods(getter))
        if(length(x) > 0)
          generic = TRUE
      }
    }
    if(!generic){
      value = function(x,...){
        y = as.character(sys.call()[[1]])
        UseMethod(y, x)
      }
      assign(paste0(names(methods)[[i]]), value, envir = envir)
    }
    method = paste(names(methods)[[i]],obj$classname,sep=".")
    value = function(x, ...){
      args = list(...)
      pos = gregexpr(".",sys.call()[[1]],fixed=T)[[1]]
      method = substr(sys.call()[[1]],1,pos[length(pos)]-1)
      funCall = x[[method]]
      do.call(funCall, args)
    }
    assign(paste0(method), value, envir = envir)
  }
}
