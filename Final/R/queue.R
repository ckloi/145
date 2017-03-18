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

newqueue <- function(){
  queue$new()
}

push <- function(obj,value){
  obj$push(value)
}

pop <- function(obj){
  obj$pop()
}
