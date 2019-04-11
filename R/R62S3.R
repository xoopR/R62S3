#' S3 Method Generator from R6 Class
#'
#' @description Auto-generates S3 generics and public methods from an R6 Class.
#' @param R6Class The R6ClassGenerator or Classname to generate public methods from
#' @param getEnvir which environment to look in to get the R6 class, default Global Environment
#' @param assignPos the position or character name of the environment in which to assign the S3 generics/methods, default Global Environment
#' @usage R62S3(R6Class, getEnvir, assignPos)
#' @return Assigns methods and generics to the chosen environment.
#' @details The input must either be of class R6ClassGenerator or a character
#'   string naming the R6ClassGenerator. Also assumes the classname is the same
#'   as the R6ClassGenerator name.
#' @examples
#' printMachine <- R6::R6Class("printMachine",
#'public = list(initialize = function() {},
#'printer = function(str) {print(str)}))
#' pm <- printMachine$new()
#' R62S3("printMachine")
#' R62S3(printMachine)
#' pm$printer("Test String A")
#' printer(pm, "Test String B")
#'
#' @export
R62S3 <- function(R6Class, getEnvir = .GlobalEnv, assignPos = ".GlobalEnv"){
  checkmate::assert(inherits(R6Class,"character"),inherits(R6Class,"R6ClassGenerator"),
         .var.name = "R6Class must either be an R6ClassGenerator or a
         character string naming a generator.")
  if(checkmate::testCharacter(R6Class))
    obj = get0(R6Class, envir = getEnvir)
  else
    obj = R6Class
  methods = obj$public_methods[!(names(obj$public_methods) %in% c("initialize","clone"))]
  for(i in 1:length(methods)){
    getter = get0(names(methods)[[i]], envir = getEnvir)
    x = FALSE
    generic = FALSE
    if(!is.null(getter)){
      x = suppressWarnings(suppressMessages((try(methods(getter),silent=T))))
      if(class(x)!="try-error"){
        x = suppressWarnings(suppressMessages(methods(getter)))
        if(length(x) > 0)
          generic = TRUE
      }
    }
    if(!generic){
      value = function(x,...){
        y = as.character(sys.call()[[1]])
        UseMethod(y, x)
      }
      assign(paste0(names(methods)[[i]]), value, pos = assignPos)
    }
    method = paste(names(methods)[[i]],obj$classname,sep=".")
    value = function(x, ...){
      args = list(...)
      pos = gregexpr(".",sys.call()[[1]],fixed=T)[[1]]
      method = substr(sys.call()[[1]],1,pos[length(pos)]-1)
      funCall = x[[method]]
      do.call(funCall, args)
    }
    assign(paste0(method), value, pos = assignPos)
  }
}
