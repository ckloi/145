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
          sumUpDown <- checkUp(index,pixAddress,pa, consec) +  checkDown(index,pixAddress,pa, consec)
          # If column has no conflict, check row
          if(sumUpDown <= consec-1){
            sumLeftRight <- checkLeft(index,pixAddress,pa, consec) + checkRight(index,pixAddress,pa,consec)
            # If row has no conflict, current pixel is ok to write to, so break
            if(sumLeftRight <= consec-1){
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
          sumUpDown <- checkUp(index,pixAddress,pa, consec) +  checkDown(index,pixAddress,pa, consec)
          # If no conflicts in column, check row
          if(sumUpDown <= consec-1){
            sumLeftRight <- checkLeft(index,pixAddress,pa, consec) + checkRight(index,pixAddress,pa,consec)
            # If no conflict in row, pixel is ok to write to, so break
            if(sumLeftRight <= consec-1){
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

checkUp <- function(index,array,pa,times){
  
  counter <- 0
  
  for ( i in 1:times ){
    
    check <- wrapAround(index-i,pa)
    
    if (check %in% array){
      counter <- counter + 1
    }else{
      break
    }
    
  }
  
  return(counter)
}

checkDown <- function(index,array,pa,times){
  
  counter <- 0
  
  for ( i in 1:times ){
    
    check <- wrapAround(index+i,pa)
    
    if (check %in% array){
      counter <- counter + 1
    }else{
      break
    }
    
  }
  
  return(counter)
}
checkLeft <- function(index,array,pa,times){
  
  counter <- 0
  
  for ( i in 1:times ){
    
    check <- wrapAround( index - i*nrow(pa),pa)
    
    if (check %in% array){
      counter <- counter + 1
    }else{
      break
    }
    
  }
  
  return(counter)
}
checkRight <- function(index,array,pa,times){
  
  counter <- 0
  
  for ( i in 1:times ){
    
    check <- wrapAround(index + i*nrow(pa),pa)
    
    if (check %in% array){
      counter <- counter + 1
    }else{
      break
    }
    
  }
  
  return(counter)
}

wrapAround  <- function(index,mat){
  
  index <- index %% length(mat)
  
  if (index == 0 ){
    index <- length(mat)
  }
  
  return(index)
}


startpixel <- 5000
stride1 <- 10000
consec <- 1
teststring <- "This is going to be a realy long sentence to test for any overwriting.
This is going to be a realy long sentence to test for"

write.pnm(secretencoder("LLL.pgm",teststring,startpixel,stride1,consec),'empty_result.pgm')
print(secretdecoder("empty_result.pgm",startpixel,stride1,consec))
