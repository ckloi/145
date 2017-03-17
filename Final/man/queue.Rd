\name{queue}
\alias{queue}

\title{Queue Data Structure}

\description{Aids in creating Queue data structures}

\usage{
  queue$new()
  obj$push(value)
  obj$pop()
}

\arguments{
  \item{obj}{The object created by \code{queue$new()}.}
  \item{value}{The element that wil be pushed onto the Queue.}
}

\details{
  A Queue data structure follows a First In First Out (FIFO) approach, similar
  to a line at the grocery store. The value first pushed to the Queue will be the first one
  removed.

  A Queue object instance is created via \code{queue$new()}. The name of this
  object will then be used to call \code{push()} and \code{pop()}.
  \code{push(value)} will add element 'value' to the back of the queue and return the
  new object.
  \code{pop()} will remove the element at the front of the Queue and return the
  element.
}

\author{
  Andrew Faust
  Chi Kei Loi
  Mano Wared
  Tingting Zhu
}
