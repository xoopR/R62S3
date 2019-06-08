#' Method Generator from R6 Class
#'
#' @description Auto-generates methods from an R6 Class.
#' @param R6Class R6ClassGenerator to generate public methods from
#' @param assignEnvir environment in which to assign the S4 generics/methods, default is parent of current environment.
#' @param detectGeneric logical, if TRUE (default) detects if the method has a S3 generic and defines function accordingly
#' @param mask logical, should the new method mask existing ones? See details.
#' @param dispatchClasses list of classes to assign S3 dispatch methods on. See Details.
#' @details Searches in a given R6 class for all public methods that are not 'initialize' or 'clone'.
#' Creates a function to call each of the R6 methods.
#'
#' Additional parameters allow the user to specify if a generic function should be detected. If so
#' then a dispatch method is created instead of a standard function. The \code{mask} parameter determines
#' if masking should occur, if TRUE then the function is created even if one of the same name
#' exists, if FALSE then the function name is appended with ".ClassName" like a dispatch method.
#'
#' If \code{mask = FALSE} or \code{detectGeneric = TRUE}, \code{dispatchClasses} specifies what class
#' the method should be associated with, i.e. \code{method.ClassName}.
#'
#' @return Assigns methods to the chosen environment.
#' @examples
#' printMachine <- R6::R6Class("printMachine",
#'public = list(initialize = function() {},
#'printer = function(str) {print(str)}))
#' pm <- printMachine$new()
#' R62Fun(printMachine, assignEnvir = .GlobalEnv)
#' pm$printer("Test String A")
#' printer(pm, "Test String B")
#'
#' @export
R62Fun <- function(R6Class, assignEnvir = parent.env(environment()),
                   detectGeneric = TRUE, mask = FALSE,
                   dispatchClasses = list(R6Class)){

  checkmate::assert(inherits(R6Class,"R6ClassGenerator"),
                    .var.name = "R6Class must be an R6ClassGenerator")

  obj = R6Class
  methods = obj$public_methods[!(names(obj$public_methods) %in% c("initialize","clone"))]

  if(!detectGeneric & mask)
    dispatchClasses = list(R6Class)

  if(length(methods)>0){
    for(i in 1:length(methods)){
      methodname = names(methods)[[i]]
      assignname = methodname

      if(detectGeneric){
        generic = FALSE
        if(mask){
          x = tryCatch(methods(methodname),warning = function(w) w, error = function(e) e)
          if(inherits(x, "condition")){
            if(!grepl("appears not to be S3 generic",x$message) & !inherits(x, "error"))
              generic = TRUE
          } else if(length(x)!=0)
            generic = TRUE
        } else{
          x = suppressWarnings(suppressMessages((try(methods(methodname),silent=T))))
          if(class(x)!="try-error"){
            if(length(x) > 0)
              generic = TRUE
          }
        }

        if(generic)
          assignname = lapply(dispatchClasses, function(x) paste(names(methods)[[i]],x$classname,sep="."))
      } else if(!mask){
        assignname = RSmisc::ifnerror(get(methodname),
                                      lapply(dispatchClasses, function(x) paste(names(methods)[[i]],x$classname,sep=".")),
                                      methodname)
      }

      for(j in 1:length(dispatchClasses)){
        value = function(object){}
        formals(value) = c(formals(value), formals(methods[[i]]))
        body(value) = substitute({
          args = as.list(match.call())
          args[[1]] = NULL
          args$object = NULL
          do.call(object[[method]], args)
        },list(method=methodname[[j]]))
        assign(assignname[[j]], value, envir = assignEnvir)
      }

    }
  }
}
