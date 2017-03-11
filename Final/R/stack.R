


Stack <- function()
{
  
  args <- list(
    arr <- vector(length=0),
    size <- 0
  )
  
  ## Set the name for the class
  
  
  class(args) <- append(class(args),"Stack")
  
  return(args)
}


push <- function(obj, newValue)
{
  print("Calling the base push function")
  UseMethod("push",obj)
}

pop <- function(obj, newValue)
{
  print("Calling the base pop function")
  UseMethod("pop",obj)
}


push.Stack <- function(obj, newValue)
{
  print("In push.Stack and setting the value")
  obj$arr <- c(obj$arr, newValue)
  x <- c(obj$size) + 1
  print(x)
  return(obj)
}

pop.Stack <- function(obj, newValue)
{
  print("In push.Stack and setting the value")
  obj$arr <- obj$arr[-obj$size]
  obj$size <- obj$size - 1
  return(obj)
}




v <- Stack()

v <- push(v,1)
#v <- push(v,2)

