#' @template R62
#' @templateVar type functions
#' @param detectGeneric logical, if TRUE (default) detects if the method has a S3 or S4 generic and defines functions accordingly
#' @details S3 generics are detected with [utils::isS3stdGeneric()] and S4 generics are detected with [methods::.S4methods()].
#'
#' @export
R62Fun <- function(R6Class, assignEnvir = parent.env(environment()),
                   detectGeneric = TRUE, mask = FALSE,
                   dispatchClasses = list(R6Class),
                   scope = "public", arg1 = "object", exclude = NULL){

  methods = .getMethods(R6Class, scope, exclude)

  if(nrow(methods) > 0){

    if(detectGeneric) {
      methods = .detectGeneric(methods, type = c("S3","S4"), mask, arg1)
    } else {
      methods = cbind(methods, data.table::data.table(generic = logical(nrow(methods)),
                                                      arg1 = rep(arg1, nrow(methods))))
    }

    if(mask){
      invisible(.assignMethods(.getBody(methods), "fun", assignEnvir, R6Class$classname, TRUE))
    else
      invisible(.assignMethods(.getBody(methods), "fun", assignEnvir,
                               sapply(dispatchClasses, function(x) x$classname)))
  }
}
