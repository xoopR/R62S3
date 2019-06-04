#' S3 Method Generator from R6 Class
#'
#' @description Auto-generates S3 generics and public methods from an R6 Class.
#' @param R6Class R6ClassGenerator to generate public methods from
#' @param dispatchClasses list of classes to assign S3 dispatch methods on
#' @param assignEnvir environment in which to assign the S3 generics/methods, default is parent of current environment.
#' @param mask logical, determines if non-generic functions should be masked if found, see details.
#' @usage R62S3(R6Class, dispatchClasses = list(R6Class), assignEnvir = parent.env(environment()),
#' mask = FALSE)
#' @details Searches in a given R6 class for all public methods that are not 'initialize' or 'clone'.
#' For each method if a generic does not already exist, one is created and assigned to the given environment.
#' Methods are created for every generic, following standard S3 convention.
#'
#' In some cases a function may be defined without being a generic, if mask is TRUE then this function
#' is masked by R62S3 and a generic is created with the same name. If mask is FALSE then this function
#' is treaed like a generic and only the method is created.
#'
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
R62S3 <- function(R6Class, dispatchClasses = list(R6Class),
                  assignEnvir = parent.env(environment()), mask = FALSE){
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
        value = function(object,...){}
        body(value) = substitute({
          UseMethod(y, object)
        },list(y=methodname))
        assign(methodname, value, envir = assignEnvir)
      }

      lapply(dispatchClasses, function(y){
        method = paste(methodname,y$classname,sep=".")
        value = function(object){}
        formals(value) = c(formals(value), formals(methods[[i]]))
        body(value) = substitute({
          args = as.list(match.call())
          args[[1]] = NULL
          args$object = NULL
          do.call(object[[method]], args)
        },list(method=methodname))
        assign(paste0(method), value, envir = assignEnvir)
      })
    }
  }
}
