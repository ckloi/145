library(R6)
queue <- R6Class("queue",
        private = list(
            arr = NA
        ),

        public = list(

          initialize = function() {
          },


          push = function(val) {
              if (is.na(private$arr[1])){
                  private$arr <- c(val)
              }else{
                  private$arr <- c(private$arr,val)
              }
              return (self)
          },


          pop = function() {
              x <- private$arr[1]
              # Don't bother doing anything if there is nothing in the queue
              if(!is.na(private$arr[1])){
                private$arr <- private$arr[-1]
              }
              return (x)
           },

          print = function() {
              if(!is.na(private$arr[1])){
                cat(private$arr)
                cat('\n')
              }
          }
        )
)




v <- queue$new()

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
a <- v$pop()
a <- v$pop()
a <- v$pop()
a <- v$pop()


v$print()
