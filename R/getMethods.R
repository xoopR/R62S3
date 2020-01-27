.getMethods <- function(class, scope, exclude) {

  stopifnot(inherits(class,"R6ClassGenerator"))

  public = active = list()

  if("public" %in% scope)
    public = class$public_methods[!(names(class$public_methods) %in% c("initialize","clone", exclude))]
  if("active" %in% scope)
    active = class$active[!(names(class$active) %in% exclude)]

  data.table::data.table(Name = names(c(public, active)), Functions = c(public, active), Scope = c(rep("public",length(public)),rep("active",length(active))))
}
