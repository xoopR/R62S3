# R62S3

[![Build Status](https://travis-ci.com/RaphaelS1/R62S3.svg?branch=master)](https://travis-ci.com/RaphaelS1/R62S3)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)
![CRAN Version](http://www.r-pkg.org/badges/version/R62S3)
![codecov](https://codecov.io/gh/RaphaelS1/R62S3/branch/master/graph/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What is R62S3?

A helper function in R to automatically generate S3 dispatch and methods from an R6ClassGenerator.
Useful to allow for a fully R6 object-oriented programming interface alongside familiar S3 dispatch, but without the need to code hundreds of lines for each S3 method.

## How to Use R62S3

R62S3 is very simple to use as it consists of one function only! The usage (with defaults) is
````R
R62S3::R62S3(R6Class, dispatchClasses = list(R6Class), assignEnvir = .GlobalEnv)
````

The parameters allow R62S3 to be a highly flexible method that can:
* Create S3 methods for any amount of R6 classes
* Add S3 methods to any R given environment (assuming unlocked)

I recommend it in your zzz.R file for any package that uses R6. This can either be done for specified classes:
````R
.onLoad <- function(libname, pkgname){
  R62S3::R62S3::R62S3(yourR6Class, assignEnvir = parent.env(environment()))
}
````

Or for every R6 class:

````R
.onLoad <- function(libname, pkgname){
  lapply(ls(name=parent.env(environment())),function(x){
    if(inherits(get(x),"R6ClassGenerator"))
      R62S3::R62S3(get(x),assignEnvir = parent.env(parent.env(environment())))
  })
}
````

## Install with

````R
devtools::install_github("RaphaelS1/R62S3")
````

### Acknowledgements
Dr Franz Kiraly for initial discussions about the idea. <br>
Prof. Dr. Peter Ruckdeschel for conversations that lead to a simplification in the code structure.
