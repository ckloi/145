library(R6)
Queue <- R6Class("Queue",
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
              x <- private$arr[1]
              private$arr <- private$arr[-1]
              if (length(private$arr) == 0){
                  private$arr <- NULL
              }
              return (x)
           },
                   
          print = function() {
              print(private$arr)
          }
        )
)




v <- Queue$new()

v$push(1)
v$push(2)
v$push(3)
v$push(4)
v$push(5)
v$push(6)
v$push(7)
a <- v$pop()
v$push(8)
v$push(-1)
v$push(-27)
v$push(-37)

a <- v$pop()
a <- v$pop()
a <- v$pop()
a <- v$pop()
a <- v$pop()
a <- v$pop()

v$print()


