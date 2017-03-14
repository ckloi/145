library(R6)
Stack <- R6Class("Stack",
                 private = list(
                   arr = NULL
                 ),
                 public = list(
                   initialize = function() {
                   },
                   push = function(val) {
                     private$arr <- c(private$arr,val)
                   },
                   pop = function() {
                     lastIndex <- length(private$arr)
                     x <- private$arr[lastIndex]
                     if (lastIndex == 1){
                       private$arr <- NULL
                     }else{
                       private$arr <- private$arr[-lastIndex]
                     }
                     return (x)
                   },
                   print = function() {
                     print(private$arr)
                   }
                 )
)




v <- Stack$new()

v$push(1)
v$push(2)
v$push(3)
v$push(4)
v$push(5)
v$push(6)
v$push(7)
a <- v$pop()

print(a)
v$print()


