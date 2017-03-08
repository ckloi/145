#Project 3
#Problem A

# This program will embed a secret message into a picture, allowing for no more
# than 'consec' adjacent pixels to be changed

library(pixmap)


secretencoder <- function(imgfilename,msg,startpix,stride,consec = NULL){
  #if file does not exist, stop
  if(!file.exists(imgfilename)){
    stop("File does not exist")
  }

  imgfile <- read.pnm(imgfilename)

  # Check if file opened correctly
  if(is.null(imgfile)){
    stop("File did not open correctly")
  }

  #extract the pixel array
  pa <- imgfile@grey
  original <- imgfile@grey

  #Check if stride is 0
  if(stride == 0){
    stop('Stride cannot be 0')
  }

  # Check if stride is relatively prime to image size
  if(length(pa)%%stride == 0){
    warning("Stride is not relatively prime to image size. Overwriting may occur.")
  }

  # Check if the length of the message is larger than the size of the image
  if(nchar(msg) > length(pa)){
    stop("Not enough space for the message.")
  }

  # Appropriate numeric values that will be added to the picture, with 0 at the
  #   end to represent the end of the message, convert msg into a vector of number
  values <- utf8ToInt(msg)/128
  values <- c(values,0.0)

  if(is.null(consec)){
    # Get indices to write to
    indices <- seq(startpix, length(values)*stride, stride)
    # Avoids indices being 0
    indices <- wrapAround(indices,pa)
    pa[indices] <- values
  }

  else {
    pixAddress <- vector(length=0)
    index <- startpix
    # Go through all elements of values and try to write them to the image
    for (i in values){
      while(1){
        # If current pixel will not be overwritten, check column for conflict
        if(!(index %in% pixAddress)){
          sumUp <- checkUp(index,pixAddress,pa)
          sumCol <- checkDown(index,pixAddress,pa,sumUp)
          # If column has no conflict, check row
          if(sumCol <= consec-1){
            sumLeft <- checkLeft(index,pixAddress,pa)
            sumRow <- checkRight(index,pixAddress,pa,sumLeft)
            # If row has no conflict, current pixel is ok to write to, so break
            if(sumRow <= consec-1){
              break
            }
          }
        }
        # If any of the above checks raise a conflicts, move on to the next index
        index <- wrapAround(index+stride,pa)
        # If the next index is the starting pixel, overwrite or previous conflicts
        #   will endlessly occur, so stop
        if(index == startpix){
          stop("Cannot find place")
        }
      }

      # Write value to current index
      pa[index] <- i
      # Record that current index has been written to
      pixAddress <- c(pixAddress,index)
      index <- wrapAround(index+stride,pa)
    }
  }
  result <- imgfile
  result@grey <- pa
  return(result)

}

secretdecoder <- function(imgfilename,startpix,stride,consec=NULL){
  #if file does nto exist, stop
  if(!file.exists(imgfilename)){
    stop("File does not exist")
  }

  if(stride > file.size(imgfilename)){
    warning("Stride is larger than the size of the file")
  }
  #read the file, if not read probably, stop

  imgfile <- read.pnm(imgfilename)
  pa <- imgfile@grey

  if(is.null(consec)){
    # Get the appropriate indices to be read from. Start from startpix and
    #   increment by stride until pa is 0 (null character)
    indices <- seq(startpix,pa[pa==0],stride)
    # Modify the indices to allow for wrap around
    indices <- wrapAround(indices,pa)
    # Read and convert the values at the indices into letters
    message <- intToUtf8(round(pa[indices]*128))
  }

  else{
    # Vector to hold positions(initialized with starting pixel)
    pixAddress <- startpix
    # Vector to hold all read characters(initialized with first character read)
    message <- intToUtf8(round(pa[startpix]*128))
    index <- wrapAround(startpix+stride,pa)
    # Loop until you reach the null character
    while(pa[index] != 0){
      while(1){
        # If pixel will not be overwritten, check columns for consecutive pixels
        if(!(index %in% pixAddress)){
          sumUp <- checkUp(index,pixAddress,pa)
          sumCol <- checkDown(index,pixAddress,pa,sumUp)
          # If no conflicts in column, check row
          if(sumCol <= consec-1){
            sumLeft <- checkLeft(index,pixAddress,pa)
            sumRow <- checkRight(index,pixAddress,pa,sumLeft)
            # If no conflict in row, pixel is ok to write to, so break
            if(sumRow <= consec-1){
              break
            }
          }
        }
        # If any of the above checks raise a conflict, move to the next index
        index <- wrapAround(index+stride,pa)
      }
      # Convert the current pixel and add it to the message vector
      message <- c(message, intToUtf8(round(pa[index]*128)))
      # Record that current index has been read
      pixAddress <- c(pixAddress, index)
      index <- wrapAround(index+stride,pa)
    }
  }

  # Combine all read characters into one string
  message <- paste(message,collapse='')
  return(message)
}

# Returns number of consecutive pixels above index
checkUp <- function(index,array,pa,counter=0,i=1){
  if(i > consec-1){
    return(counter)
  }

  check <- wrapAround(index-i,pa)
  if(check %in% array){
    return(checkDown(check,array,pa,counter+1,i+1))
  }
  return(counter)
}

# Returns number of consecutive pixels below index
checkDown <- function(index,array,pa,counter,i=1){
  if(i > consec-1){
    return(counter)
  }
  check <- wrapAround(index+i,pa)
  if(check %in% array){
    return(checkDown(check,array,pa,counter+1,i+1))
  }
  return(counter)
}

# Returns number of consecutive pixels to the left of index
checkLeft <- function(index,array,pa,counter=0,i=1){
  if(i > consec-1){
    return(counter)
  }

  check <- wrapAround(index-i*nrow(pa),pa)
  if(check %in% array){
    return(checkRight(check,array,pa,counter+1,i+1))
  }
  return(counter)
}

# Returns number of consecutive pixels to the right of index
checkRight <- function(index,array,pa,counter=0,i=1){
  if(i > consec-1){
    return(counter)
  }

  check <- wrapAround(index+i*nrow(pa),pa)
  if(check %in% array){
    return(checkRight(check,array,pa,counter+1,i+1))
  }
  return(counter)
}

# Modifies index to wrap around if needed
wrapAround  <- function(index,mat){
  if (index > length(mat)){
    index <- index - length(mat)
  }
  return(index)
}

startpixel <- 78
stride1 <- 0
consec <- 2
teststring <- "This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting.
              This is going to be a realy long sentence to test for any overwriting."

write.pnm(secretencoder("small_test.pgm",teststring,startpixel,stride1,consec),'small_result.pgm')
print(secretdecoder("small_result.pgm",startpixel,stride1,consec))
