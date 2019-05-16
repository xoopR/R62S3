#' S3 Method Generator from R6 Class
#'
#' @description Auto-generates S3 generics and public methods from an R6 Class.
#' @param R6Class R6ClassGenerator to generate public methods from
#' @param dispatchClasses list of classes to assign S3 dispatch methods on
#' @param assignEnvir environment in which to assign the S3 generics/methods, default is parent of current environment.
#' @usage R62S3(R6Class, dispatchClasses = list(R6Class), assignEnvir = parent.env(environment()))
#' @details Searches in a given R6 class for all public methods that are not 'initialize' or 'clone'.
#' For each method if a generic does not already exist, one is created and assigned to the given environment.
#' Methods are created for every generic, following standard S3 convention.
#' @return Assigns methods and generics to the chosen environment.
#' @examples
#' printMachine <- R6::R6Class("printMachine",
#'public = list(initialize = function() {},
#'printer = function(str) {print(str)}))
#' pm <- printMachine$new()
#' R62S3(printMachine, assignEnvir = .GlobalEnv)
#' pm$printer("Test String A")
#' printer(pm, "Test String B")
#'
#' @export
R62S3 <- function(R6Class, dispatchClasses = list(R6Class), assignEnvir = parent.env(environment())){
  checkmate::assert(inherits(R6Class,"R6ClassGenerator"),
         .var.name = "R6Class must be an R6ClassGenerator")

  obj = R6Class
  methods = obj$public_methods[!(names(obj$public_methods) %in% c("initialize","clone"))]

  if(length(methods)>0){
    for(i in 1:length(methods)){
      methodname = names(methods)[[i]]

      generic = FALSE
      x = suppressWarnings(suppressMessages((try(methods(methodname),silent=T))))
      if(class(x)!="try-error"){
        if(length(x) > 0)
          generic = TRUE
      }

      if(!generic){
        value = function(x,...){}
        body(value) = substitute({
          UseMethod(y, x)
        },list(y=methodname))
        assign(methodname, value, envir = assignEnvir)
      }

      lapply(dispatchClasses, function(y){
        method = paste(methodname,y$classname,sep=".")
        value = function(x, ...){}
        body(value) = substitute({
          args = list(...)
          do.call(x[[method]], args)
        },list(method=methodname))
        assign(paste0(method), value, envir = assignEnvir)
      })
    }
  }
}
