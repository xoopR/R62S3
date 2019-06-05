#' Method Generator from R6 Class
#'
#' @description Auto-generates methods from an R6 Class.
#' @param R6Class R6ClassGenerator to generate public methods from
#' @param assignEnvir environment in which to assign the S4 generics/methods, default is parent of current environment.
#' @usage R62Fun(R6Class, assignEnvir = parent.env(environment()))
#' @details Searches in a given R6 class for all public methods that are not 'initialize' or 'clone'.
#' For each method if a generic does not already exist, one is created and assigned to the given environment.
#' Methods are created for every generic, following standard S4 convention.
#' @return Assigns methods and generics to the chosen environment.
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
R62Fun <- function(R6Class, assignEnvir = parent.env(environment())){

  checkmate::assert(inherits(R6Class,"R6ClassGenerator"),
                    .var.name = "R6Class must be an R6ClassGenerator")

  obj = R6Class
  methods = obj$public_methods[!(names(obj$public_methods) %in% c("initialize","clone"))]

  if(length(methods)>0){
    for(i in 1:length(methods)){
      methodname = names(methods)[[i]]
      value = function(object){}
      formals(value) = c(formals(value), formals(methods[[i]]))
      body(value) = substitute({
        args = as.list(match.call())
        args[[1]] = NULL
        args$object = NULL
        do.call(object[[method]], args)
      },list(method=methodname))
      assign(methodname, value, envir = assignEnvir)
    }
  }
}
