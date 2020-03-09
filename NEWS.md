# R62S3 1.4.1

* Fixed breakage due to `plot` being moved from `graphics` to `base`

# R62S3 1.4.0

## Minor Updates

* Minor updates to the whole package, backwards compatibility may be affected
* `mask` now applies to well-defined `S3` and `S4` methods only. This may affect backwards compatibility. Checking `S3` generics uses `utils::isS3stdGeneric` and checking `S4` generics uses `methods::.S4methods`, any other generic/method definitions are not recognised.
* Added support for *read-only* active bindings. A new `scope` argument allows the choice between generating public methods `"public"`, active bindings `"active"`, or both `c("public", "active")`. Support for all active bindings will be added in the future.
* Added support for excluding methods/bindings. A new `exclude` argument allows specific methods or bindings to be ignored by the generator.
* Added support to change the name of the dispatch object. The first argument in dispatch is used in the generic and method definition. The name of this argument can be changed by using the `arg1` argument. 

## Patches
* Documentation unified across all three functions
* Backend abstracted into multiple helper functions
* Optimised code, all `for` loops removed


# R62S3 1.3.1

* Added R62S4
  * Extends to R62S3 to generate S4 generics and methods instead
* Added R62Fun
  * Generates functions and no generics, dispatch methods if generics are found
* Edited R62S3
  * Bug fixes in assignment
  * Bug fixes in finding generics
  * Adds functionality for masking

# R62S3 1.2.1

* Released to CRAN!
* Note Fix: Title to Title Case
* Bug Fix: Moved R6 from Imports to Suggests
* Removed unnecessary `getEnvir`
* Simplified code by removing redundant conditional

# R62S3 1.0.0

* Stable release onto GitHub.
