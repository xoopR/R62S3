#' @template R62
#' @templateVar type S3
#' @details S3 generics are detected with [utils::isS3stdGeneric()].
#' @export
R62S3 <- function(R6Class, dispatchClasses = list(R6Class),
                  assignEnvir = parent.env(environment()), mask = FALSE,
                  scope = "public", arg1 = "object", exclude = NULL){

  methods = .getMethods(R6Class, scope, exclude)

  if(nrow(methods) > 0) {
    methods = .detectGeneric(methods, type = "S3", mask, arg1)
    .makeGeneric(methods, "S3", assignEnvir)

    dispatch_names = sapply(dispatchClasses, function(x) x$classname)
    invisible(.assignMethods(.getBody(methods), "S3", assignEnvir, dispatch_names))
  }

}
