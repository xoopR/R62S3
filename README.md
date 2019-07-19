# R62S3

[![Travis Build Status](https://travis-ci.com/RaphaelS1/R62S3.svg?branch=master)](https://travis-ci.com/RaphaelS1/R62S3)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/olstl9l368ofl5el?svg=true)](https://ci.appveyor.com/project/RaphaelS1/r62s3)
[![Lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)
[![codecov](https://codecov.io/gh/RaphaelS1/R62S3/branch/master/graph/badge.svg)](https://codecov.io/gh/RaphaelS1/R62S3/branch/master/graph/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CRAN Version](http://www.r-pkg.org/badges/version-ago/R62S3)](http://www.r-pkg.org/badges/version/R62S3)
[![CRAN Summary](http://cranlogs.r-pkg.org/badges/grand-total/R62S3)](http://cranlogs.r-pkg.org/badges/grand-total/R62S3)
[![CRAN Checks](https://cranchecks.info/badges/summary/R62S3)](https://cran.r-project.org/web/checks/check_results_R62S3.html)
[![Dependencies](https://tinyverse.netlify.com/badge/R62S3)](https://CRAN.R-project.org/package=R62S3)

## What is R62S3?

R62S3 started as a single function, `R62S3`, and has since grown into two new functions called `R62S4` and `R62Fun` however instead of changing the original name, it remains as a legacy to the single function where it all began (also because it requires less pleading with CRAN).

R62S3 was created as a way to automatically generate S3 generics and dispatch methods from an R6ClassGenerator. This allows the user to build a fully R6 object-oriented programming interface alongside familiar S3 dispatch, but without the need to code hundreds of lines for each S3 method.

Unsurprisingly, R62S4 is an analogous function that creates S4 generics and methods instead of S3 ones.

R62Fun creates functions that aren't necessarily dispatch methods. Additional arguments are used to specify what should happen if one of these functions could mask others or if generics exist.

## Choosing between R62S3, R62S4 and R62Fun

There are a few choices to make when deciding between which of these to implement, they mainly come down to when the function will be called, if the resulting assignments need to be documented and if generics are genuinely useful. We break down these decisions below to help you decide.

### When will the function be called?

In deciding which of the `R62` functions to use, the first consideration is when will it be called. For example will you be implementing it directly into your package (as below), which means that your package is shipped with the S3 methods, or will you direct the user to the function so that they can call it only if they choose. If you are giving the user the flexibility to choose, then you can also give them the option to choose any of three, however in this case only `R62Fun` should be required as the user can assign all methods to `.GlobalEnv` and will be able to see the names of all functions easily.

### Documentation

This section assumes that you are building a package to be exported to CRAN and that you are using roxygen for your documentation. In this case, roxygen requires quite strict conventions for function exporting. We have found that in practice it is next to impossible to dynamically assign S3 generics and methods to the package environment and successfully document the generics/methods in a way that allows I) correct documentation and II) the correct methods exported. S4 generics don't have the same problem as S4 methods are automatically set to be in the same namespace as S4 generics and thus exported together. `R62Fun` doesn't have this problem either as functions are dynamically assigned to the package namespace and exporting these functions can be done by documenting on a `NULL`. For example, if you are using `R62Fun` on a class with the function `printer` then you document the function that will be created as follows:

````R
@name printer
@title Printer Method
....
@export
NULL
````

### Is a generic useful?

In choosing between the three functions, a big consideration is whether creating a new generic function is actually useful. All of these methods define the dispatch method (or function) in the same way, they all take the name of the function and pass it to the corresponding R6 class, so internally they look identical. The power of dispatch lies in the fact that methods with the same name can look the same externally but act differently internally, but in this case they all act the same internally! Therefore you should consider if creating a generic is useful. A generic is useful if you can answer the following two questions positively:
1. The generic will be re-used by a non-R62S3/4 generated method somewhere else in the package
1. The generic will be re-used outside of the package (perhaps by being called from a different package)
If you can answer 'yes' to both of these then use `R62S3` or `R62S4` otherwise `R62Fun` should suffice.

## Where to use the R62 family?

If you are using a `R62` function in a package that will be exported and shared, I recommend creating a `zzz.R` file and adding the function there. This can either be done for specified classes:
````R
R62S3::R62S3(yourR6Class, assignEnvir = topenv())
}
````

Or for every R6 class:

````R
lapply(ls(name=parent.env(environment())),function(x){
  if(inherits(get(x),"R6ClassGenerator"))
    R62S3::R62S3(get(x),assignEnvir = topenv())
  })
````

### distr6 Use-Case

To see `R62S3` in action, check out the (distr6)[https://cran.r-project.org/web/packages/distr6/index.html] package (Sonabend and Kiraly, 2019). In `distr6` we use the `R62Fun` functions in our `zzz.R` file to generate S3 methods from specified R6 classes. This package also demonstrates how to document these functions.

## Installation

For a stable release, install from CRAN
````R
install.packages("R62S3")
````

Or install the latest build from GitHub with

````R
remotes::install_github("RaphaelS1/R62S3")
````

### Acknowledgements
Dr Franz Kiraly for initial discussions about the idea. <br>
Prof. Dr. Peter Ruckdeschel for conversations that lead to a simplification in the code structure.
