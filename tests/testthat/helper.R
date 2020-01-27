R62S3lower = function(object, ...) UseMethod("R62S3lower", object)
R62S4lower = function(object, ...) UseMethod("R62S4lower", object)
R62Funlower = function(object, ...) UseMethod("R62Funlower", object)

methods::setGeneric("R62S3upper", function(object, ...){}, where = .GlobalEnv)
methods::setGeneric("R62S4upper", function(object, ...){}, where = .GlobalEnv)
methods::setGeneric("R62Funupper", function(object, ...){}, where = .GlobalEnv)

for (i in c("R62S3", "R62S4", "R62Fun")) {
  assign(paste(i, "S3Generic", sep = "_"),
       R6::R6Class(paste(i, "S3Generic", sep = "_"),
                   public = list(excluder = function() return("Excluded"))))

  get(paste(i, "S3Generic", sep = "_"))[["set"]]("public", paste0(i, "lower"), function(x) tolower(x))
  get(paste(i, "S3Generic", sep = "_"))[["set"]]("active", paste0(i, "StatusA"), function() return("Printing"))

  assign(paste(i, "S4Generic", sep = "_"),
         R6::R6Class(paste(i, "S4Generic", sep = "_"),
                     public = list(excluder = function() return("Excluded"))))

  get(paste(i, "S4Generic", sep = "_"))[["set"]]("public", paste0(i, "upper"), function(x) toupper(x))
  get(paste(i, "S4Generic", sep = "_"))[["set"]]("active", paste0(i, "StatusB"), function() return("Printing"))

  assign(paste(i, "NoGeneric", sep = "_"),
         R6::R6Class(paste(i, "NoGeneric", sep = "_"),
                     public = list(excluder = function() return("Excluded"))))

  get(paste(i, "NoGeneric", sep = "_"))[["set"]]("public", paste0(i, "printer"), function(x) x)
  get(paste(i, "NoGeneric", sep = "_"))[["set"]]("active", paste0(i, "StatusC"), function() return("Printing"))
}

rm(i)
