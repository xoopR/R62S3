library(R6)
Queue <- R6Class("Queue",
                 public = list(
                   initialize = function(...) {
                     for (item in list(...)) {
                       self$add(item)
                     }
                   },
                   add = function(x) {
                     private$queue <- c(private$queue, list(x))
                     invisible(self)
                   },
                   remove = function() {
                     if (private$length() == 0) return(NULL)
                     # Can use private$queue for explicit access
                     head <- private$queue[[1]]
                     private$queue <- private$queue[-1]
                     head
                   }
                 ),
                 private = list(
                   queue = list(),
                   length = function() base::length(private$queue)
                 )
)

R62S3("Queue")
q <- Queue$new(5, 6, "foo")
add(q,"Something")
q$.__enclos_env__$private$queue
remove(q)
remove(q)
q$.__enclos_env__$private$queue
