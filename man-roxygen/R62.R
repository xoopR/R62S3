#' @title <%= if(type %in% c("S3", "S4")) type %> Method Generator from R6 Class
#' @description Auto-generates <%=type%> <%= if(type %in% c("S3", "S4")) "generics" %> from an R6 Class.
#' @param R6Class R6ClassGenerator to generate public methods from
#' @param dispatchClasses list of classes to assign dispatch methods on
#' @param assignEnvir environment in which to assign the generics/methods, default is parent of current environment.
#' @param mask logical, determines if non-generic functions should be masked if found, see details.
#' @param scope determines the scope of methods that should be copied, either `"public"`, `"active"` or both
#' @param arg1 if `mask == TRUE` or no generic is found, then `arg1` determines what name to give to the first argument in the generic.
#' @param exclude an optional character vector naming the public methods or active bindings to exclude from the generator
#' @details If `scope == "public"` then searches in a given [R6::R6Class] for all public methods that are not `initialize` or `clone`.
#' If `scope == "active"` then searches for all active bindings. Currenty there is only support for
#' calling active bindings but not setting them. If `scope == c("public", active")` then both are included.
#' Any methods/bindings passed to `exclude` will be ignored in the search.
#'
#' If `mask == TRUE` then the generator ignores if a generic or method of the same name exists and will
#' create a new <%= if(type %in% c("S3", "S4")) paste(type, "generic/method") else "function"%>. If
#' `mask == FALSE` then the generator will create a new generic only if an existic generic does not
#' already exist. Methods and generics are created using standard convention.
#'
#' The optional `dispatchClasses` argument takes a list of [R6::R6Class]es and allows methods to be
#' created for multiple classes at one time.
#'
#' @return None. Assigns generics/methods/functions to the chosen environment.
#' @family R62s
#' @examples
#' printMachine <- R6::R6Class("printMachine",
#'         public = list(initialize = function() {},
#'                       printer = function(str) print(str)),
#'         active = list(print = function() "Printing"))
#'
#' pm <- printMachine$new()
#'
#' # scope = public
#'
#' <%= if(type %in% c("S3", "S4")) paste0("R62", type, "(printMachine, assignEnvir = topenv())") else "R62Fun(printMachine, assignEnvir = topenv())" %>
#' printer(pm, "Test String B")
#'
#' # mask = FALSE, scope = active
#' <%= if(type %in% c("S3", "S4")) paste0("R62", type, "(printMachine, assignEnvir = topenv(), scope = 'active')") else "R62Fun(printMachine, assignEnvir = topenv(), scope = 'active')" %>
#' # note support for accessing only, cannot assign values to an active binding
#' print.printMachine(pm)
#' print(pm)
