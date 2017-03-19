\name{queue}
\alias{queue}
\alias{newqueue}

\title{Queue Data Structure}

\description{Aids in creating Queue data structures}

\usage{
  newqueue()
  push(obj,value)
  pop(obj)
}

\arguments{
  \item{obj}{The object created by \code{newqueue}.}
  \item{value}{The element that wil be pushed onto the Queue.}
}

\details{
  A Queue data structure follows a First In First Out (FIFO) approach, similar
  to a line at the grocery store. The value first pushed to the Queue will be the first one
  removed.

  To create a new queue instance, simply call \code{newqueue} and assign it to
  a variable of your choice.
  \code{push} will push the specified element onto the back of the specified queue
  instance.
  \code{pop} will remove and return the object at the front of the specified queue
  instance.

  Printing an empty Queue instance will result in no ouput.
}

\examples{
  # Instantiate a new Queue instance
  myQueue <- newqueue()

  # Push 23, 12, 20, and 6 onto the Queue
  push(myQueue,23)
  push(myQueue,12)
  push(myQueue,20)
  push(myQueue,6)

  # Print the Queue. Should output '23 12 20 6'
  print(myQueue)

  # Pop off the first 2 elements of the Queue, assign them to w and x
  w <- pop(myQueue)
  x <- pop(myQueue)

  # Print w and x. Should output 23 and 12, respectively.
  print(w)
  print(x)

  # Print the Queue. Should output '20 6'
  print(myQueue)

  # Pop the remaining two elements off the Queue and assign them to y and z,
  #   respectively.
  y <- pop(myQueue)
  z <- pop(myQueue)

  # Print y and z. Should output 20 and 6, respectively.
  print(y)
  print(z)

  # Print the Queue object. Since the object is empty, there will be no output.
  print(myQueue)
}

\author{
  Andrew Faust,
  Chi Kei Loi,
  Mano Wared,
  Tingting Zhu
}
