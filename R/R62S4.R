#' @template R62
#' @templateVar type S4
#' @details S4 generics are detected with [methods::.S4methods].
#'
#' @return Assigns methods and generics to the chosen environment.
#'
#' @export
#' @seealso [methods::setMethod] [methods::setGeneric]
R62S4 <- function(R6Class, dispatchClasses = list(R6Class),
                  assignEnvir = parent.env(environment()),
                  mask = FALSE, scope = "public", arg1 = "object", exclude = NULL){

  checkmate::assert(inherits(R6Class,"R6ClassGenerator"),
                    .var.name = "R6Class must be an R6ClassGenerator")

  methods = .getMethods(R6Class, scope, exclude)

  if(nrow(methods) > 0) {
    methods = .detectGeneric(methods, type = "S4", mask, arg1)
    .makeGeneric(methods, "S4", assignEnvir)

    dispatch_names = sapply(dispatchClasses, function(x) x$classname)
    invisible(.assignMethods(.getBody(methods), "S4", assignEnvir, dispatch_names))
  }
}
