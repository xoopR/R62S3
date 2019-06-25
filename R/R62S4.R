#' S4 Method Generator from R6 Class
#'
#' @description Auto-generates S4 generics and public methods from an R6 Class.
#' @param R6Class R6ClassGenerator to generate public methods from
#' @param dispatchClasses list of classes to assign S4 dispatch methods on
#' @param assignEnvir environment in which to assign the S4 methods, default is parent of current environment.
#' @param mask logical, determines if non-generic functions should be masked if found, see details.
#' @details Searches in a given R6 class for all public methods that are not 'initialize' or 'clone'.
#' For each method if a generic does not already exist, one is created and assigned to the given environment.
#' Methods are created for every generic, following standard S4 convention.
#'
#' In some cases a function may be defined without being a generic, if mask is TRUE then this function
#' is masked by R62S4 and a generic is created with the same name. If mask is FALSE then this function
#' is treated like a generic and only the method is created.
#'
#' @return Assigns methods and generics to the chosen environment.
#' @examples
#' printMachine <- R6::R6Class("printMachine", public = list(initialize = function() {},
#'                             printer = function(str) {print(str)}))
#' pm <- printMachine$new()
#' R62S4(printMachine, assignEnvir = .GlobalEnv)
#' pm$printer("Test String A")
#' printer(pm, "Test String B")
#'
#' @export
R62S4 <- function(R6Class, dispatchClasses = list(R6Class),
                  assignEnvir = parent.env(environment()),
                  mask = FALSE){
  checkmate::assert(inherits(R6Class,"R6ClassGenerator"),
                    .var.name = "R6Class must be an R6ClassGenerator")

  obj = R6Class
  methods = obj$public_methods[!(names(obj$public_methods) %in% c("initialize","clone"))]

  if(length(methods)>0){
    for(i in 1:length(methods)){
      methodname = names(methods)[[i]]

      generic = FALSE

      if(mask){
        x = tryCatch(methods(methodname),warning = function(w) w, error = function(e) e)
        if(inherits(x, "condition")){
          if(!grepl("appears not to be S3 generic",x$message) & !inherits(x, "error"))
            generic = TRUE
        } else
          generic = TRUE
      } else{
        x = suppressWarnings(suppressMessages((try(methods(methodname),silent=T))))
        if(class(x)!="try-error"){
          if(length(x) > 0)
            generic = TRUE
        }
      }

      if(!generic){
        def = function(object, ...){}
        methods::setGeneric(methodname, def = def, where = assignEnvir)
      }

      lapply(dispatchClasses, function(x) methods::setOldClass(x$classname, where = assignEnvir))
      arg1 = formals(get(methodname))[1]
      value = function(){}
      formals(value) = c(arg1,formals(methods[[i]]),alist(...=))
      body(value) = substitute({
        args = as.list(match.call())
        args[[1]] = NULL
        args$object = NULL
        do.call(get(object)[[method]], args)
      },list(method=methodname, object = names(arg1)[[1]]))
      lapply(dispatchClasses, function(x){
        methods::setMethod(methodname, x$classname, def = value, where = assignEnvir)
      })
    }
  }
}
