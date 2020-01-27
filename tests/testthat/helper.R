lower = function(object, ...) UseMethod(lower, object)
methods::setGeneric("upper", function(object, ...){}, where = .GlobalEnv)

S3Generic = R6::R6Class("S3Generic",
                        public = list(lower = function(x) tolower(x),
                                      excluder = function() return("Excluded")),
                        active = list(Status = function() return("Printing")))

S4Generic = R6::R6Class("S4Generic",
                        public = list(upper = function(x) toupper(x),
                                      excluder = function() return("Excluded")),
                        active = list(Status = function() return("Printing")))

NoGeneric = R6::R6Class("NoGeneric",
                        public = list(printer = function(x) x,
                                      excluder = function() return("Excluded")),
                        active = list(Status = function() return("Printing")))
