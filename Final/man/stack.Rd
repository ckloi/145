\name{stack}
\alias{stack}
\alias{newstack}

\title{Stack Data Structure}

\description{Aids in creating Stacks in R}

\usage{
  newstack()
  push(obj,value)
  pop(obj)
  print(obj)
}

\arguments{
  \item{obj}{The object created by newstack().}
  \item{value}{The element to be pushed onto the stack.}
}

\details{
  A Stack data structure follows a Last In First Out (LIFO) approach. In other
  words, the last object pushed onto a Stack will be the first one removed.

  To initiate an instance of a new stack object, call \code{newstack()} and assign
  it to a variable of your choice.
  \code{push} will push the specified element onto the front of the specified stack
  instance.
  \code{pop} will remove and return the element at the front of the specified stack
  instance.

  Printing an empty Stack instance will result in no output.
}

\examples{
  # Instantiate a new stack instance
  myStack <- newstack()

  # Push 23, 12, 20, and 6 onto the stack
  push(myStack,23)
  push(myStack,12)
  push(myStack,20)
  push(myStack,6)

  # Print the stack. Should output '23 12 20 6'
  print(myStack)

  # Pop off the first 2 elements of the stack, assign them to w and x
  w <- pop(myStack)
  x <- pop(myStack)

  # Print w and x. Should output 6 and 20, respectively.
  print(w)
  print(x)

  # Print the stack. Should output '23 12'
  print(myStack)

  # Pop the remaining two elements off the stack and assign them to y and z,
  #   respectively.
  y <- pop(myStack)
  z <- pop(myStack)

  # Print y and z. Should output 12 and 23, respectively.
  print(y)
  print(z)

  # Print the stack object. Since the object is empty, there will be no output.
  print(myStack)
}

\author{
  Andrew Faust,
  Chi Kei Loi,
  Mano Wared,
  Tingting Zhu
}
