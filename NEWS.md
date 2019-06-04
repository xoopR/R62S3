# R62S3 1.4.1

* Bug fixes due to masking update

# R62S3 1.4.0

* Dispatch argument update!
  * Previously generics were defined by the formals `generic(object,...)` and methods via dispatch were defined similarly. However this caused issues with documentation. Now methods automatically find the correct arguments from the R6 method and add them as formals.
* Added mask parameter
  * Gives the option to mask functions that are not generics but for which a dispatch method of the same name is required

# R62S3 1.3.0
* Changed the way a generic is defined to test for both errors "no function visible" and warnings "acts like an S3 but isn't"
* Updated readme to reflect use of onAttach and as.environment("package:yourpkgname")


# R62S3 1.2.1

* Documentation update to match 1.1.0

# R62S3 1.1.2

* Note Fix: Title to Title Case

# R62S3 1.1.1

* Bug Fix: Moved R6 from Imports to Suggests

# R62S3 1.1.0

* Removed unnecessary `getEnvir`
* Simplified code by removing redundant conditional

# R62S3 1.0.1

Fixed errors in DESCRIPTION and docs.

# R62S3 1.0.0

Stable release onto GitHub.