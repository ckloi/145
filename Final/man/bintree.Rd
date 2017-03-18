\name{bintree}
\alias{bintree}
\alias{newbintree}

\title{Binary Tree Data Structure}

\description{Aids in creating a sorted Binary Tree data structure}

\usage{
  newbintree()
  push(obj,value)
  pop(obj)
}

\arguments{
  \item{obj}{The object created by \code{newbintree}.}
  \item{value}{The element that wil be pushed onto the Binary Tree.}
}

\details{
  A sorted Binary Tree is a data structure that sorts values as they are
  inserted in a time efficient manner. Unfortuantely, R does not have the
  ability to use pointers, which are used to create Binary Trees in other
  languages. This class makes use of R's array to mimic the use of pointers.
  Keep in mind that this class is not space efficient.

  To create a new bintree instance, simply call \code{newbintree} and assign it
  to a variable of your choice.
  \code{push} will push the specified element onto the specified bintree instance.
  \code{pop} will remove and return the smallest element in the specified bintree
  instance.

  Printing out an empty bintree object will result in no output.
}

\examples{
  # Instantiate a new bintree instance
  myTree <- newbintree()

  # Push 23, 12, 20, and 6 onto the tree
  push(myTree,23)
  push(myTree,12)
  push(myTree,20)
  push(myTree,6)

  # Print the tree. Should output '6 12 20 23'
  print(myTree)

  # Pop off the first 2 elements of the tree, assign them to w and x
  w <- pop(myTree)
  x <- pop(myTree)

  # Print w and x. Should output 6 and 12, respectively.
  print(w)
  print(x)

  # Print the tree. Should output '20 23'
  print(myTree)

  # Pop the remaining two elements off the tree and assign them to y and z,
  #   respectively.
  y <- pop(myTree)
  z <- pop(myTree)

  # Print y and z. Should output 20 and 23, respectively.
  print(y)
  print(z)

  # Print the tree. Since the tree is empty, there will be no output.
  print(myTree)
}

\author{
  Andrew Faust,
  Chi Kei Loi,
  Mano Wared,
  Tingting Zhu
}
