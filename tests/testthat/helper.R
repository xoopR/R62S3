lower = function(object, ...) UseMethod(lower, object)
methods::setGeneric("upper", function(object, ...){}, where = .GlobalEnv)

for (i in c("R62S3", "R62S4", "R62Fun")) {
  assign(paste(i, "S3Generic", sep = "_"),
         R6::R6Class(paste(i, "S3Generic", sep = "_"),
                     public = list(lower = function(x) tolower(x),
                                   excluder = function() return("Excluded")),
                     active = list(Status = function() return("Printing"))))

  assign(paste(i, "S4Generic", sep = "_"),
         R6::R6Class(paste(i, "S4Generic", sep = "_"),
                     public = list(upper = function(x) toupper(x),
                                   excluder = function() return("Excluded")),
                     active = list(Status = function() return("Printing"))))

  assign(paste(i, "NoGeneric", sep = "_"),
         R6::R6Class(paste(i, "NoGeneric", sep = "_"),
                     public = list(printer = function(x) x,
                                   excluder = function() return("Excluded")),
                     active = list(Status = function() return("Printing"))))
}

rm(i)
