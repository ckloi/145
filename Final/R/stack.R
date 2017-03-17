library(R6)
stack <- R6Class("stack",
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
               lastIndex <- length(private$arr)
               x <- private$arr[lastIndex]
               if (lastIndex > 0){
                  private$arr <- private$arr[-lastIndex]
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

v <- stack$new()

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
#v$push(7)

v$print()
