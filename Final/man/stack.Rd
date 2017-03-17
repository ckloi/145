\name{stack}
\alias{stack}

\title{Stack Data Structure}

\description{Aids in creating stacks in R}

\usage{
  stack$new()
  obj$push(value)
  obj$pop()
}

\arguments{
  \item{value}{The element to be pushed -onto the stack.}
\item{obj}{The object created by stack$new().}
}

\details{
  A Stack data structure follows a Last In First Out (LIFO) approach. In other
  words, the last object pushed onto a Stack will be the first one removed.

  \code{stack$new()} must be assigned to a variable, as it returns an instance
  of an object.
  \code{push()} will push the specified element onto the front of the Stack.
  \code{pop()} will remove and return the element at the front of the Stack.
}

\author{
  Andrew Faust,
  Chi Kei Loi,
  Mano Wared,
  Tingting Zhu
}
