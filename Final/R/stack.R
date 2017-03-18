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

newstack <- function(){
  stack$new()
}

push <- function(obj,value){
  obj$push(value)
}

pop <- function(obj){
  obj$pop()
}
