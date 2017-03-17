\name{bintree}
\alias{bintree}

\title{Binary Tree Data Structure}

\description{Aids in creating a sorted Binary Tree data structure}

\usage{
  bintree$new()
  obj$push(value)
  obj$pop()
}

\arguments{
  \item{obj}{The object created by \code{queue$new()}.}
\item{value}{The element that wil be pushed onto the Binary Tree.}
}

\details{
  A sorted Binary Tree is a data structure that sorts values as they are
  inserted in a time efficient manner. Unfortuantely, R does not have the
  ability to use pointers, which are used to create Binary Trees in other
  languages. This class makes use of R's array to mimic the use of pointers.

  A new Binary Tree instance is created using \code{bintree$new()}. The object
  will then be used when calling the \code{push()} and \code{pop()} functions.

  \code{push()} simply pushes the specified element onto the tree in the appropriate
  position so the tree is sorted from least to gratest.

  \code{pop()} will remove the smallest element of the tree, and return the element.
}

\author{
  Andrew Faust,
  Chi Kei Loi,
  Mano Wared,
  Tingting Zhu
}
