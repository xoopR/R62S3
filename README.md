# R62S3

[![Travis Build Status](https://travis-ci.com/RaphaelS1/R62S3.svg?branch=master)](https://travis-ci.com/RaphaelS1/R62S3)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/olstl9l368ofl5el?svg=true)](https://ci.appveyor.com/project/RaphaelS1/r62s3)
[![Lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)
[![codecov](https://codecov.io/gh/RaphaelS1/R62S3/branch/master/graph/badge.svg)](https://codecov.io/gh/RaphaelS1/R62S3/branch/master/graph/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CRAN Version](http://www.r-pkg.org/badges/version-ago/R62S3)](http://www.r-pkg.org/badges/version/R62S3)
[![CRAN Summary](http://cranlogs.r-pkg.org/badges/grand-total/R62S3)](http://cranlogs.r-pkg.org/badges/grand-total/R62S3)

## What is R62S3?

A helper function in R to automatically generate S3 dispatch and methods from an R6ClassGenerator.
Useful to allow for a fully R6 object-oriented programming interface alongside familiar S3 dispatch, but without the need to code hundreds of lines for each S3 method.

## How to Use R62S3

R62S3 is very simple to use as it consists of one function only! The usage (with defaults) is
````R
R62S3::R62S3(R6Class, dispatchClasses = list(R6Class), assignEnvir = parent.env(environment())
````

The parameters allow R62S3 to be a highly flexible method that can:
* Create S3 methods for any amount of R6 classes
* Add S3 methods to any R given environment (assuming unlocked)

I recommend it in your zzz.R file for any package that uses R6. This can either be done for specified classes:
````R
.onAttach <- function(libname, pkgname){
  R62S3::R62S3(yourR6Class, assignEnvir = as.environment("package:yourpkgname"))
}
````

Or for every R6 class:

````R
.onLoad <- function(libname, pkgname){
  lapply(ls(name=parent.env(environment())),function(x){
    if(inherits(get(x),"R6ClassGenerator"))
      R62S3::R62S3(get(x),assignEnvir = as.environment("package:yourpkgname"))
  })
}
````

## Installation

For a stable release, install from CRAN
````R
install.packages("R62S3")
````

Or install the latest dev build with

````R
devtools::install_github("RaphaelS1/R62S3", "dev")
````

### Acknowledgements
Dr Franz Kiraly for initial discussions about the idea. <br>
Prof. Dr. Peter Ruckdeschel for conversations that lead to a simplification in the code structure.
