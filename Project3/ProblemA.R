#Project 3
#Problem A

# This program will embed a secret message into a picture, allowing for no more
# than 'consec' adjacent pixels to be changed

library(pixmap)

# This function allows for wrap-around of matrix 'mat' and stops index from being 0
#   (since result of mod could be 0, and R starts at 1 for indices)
modifyindex <- function(index,mat){
  return(ifelse(index%%length(mat),index%%length(mat),length(mat)))
}


secretencoder <- function(imgfilename,msg,startpix,stride,consec = NULL){
  #if file does nto exist, stop
  if(!file.exists(imgfilename)){
    stop("File does not exist")
  }

  imgfile <- read.pnm(imgfilename)
  if(is.null(imgfile)){
    stop("File did not open correctly")
  }
  #extract the pixel array
  pa <- imgfile@grey

  if(stride%%length(pa) == 0){
    warning("Stride is not relatively prime to image size. Overwriting may occur.")
  }
  if(length(msg) > length(pa)){
    stop("Not enough space for the message.")
  }

  # Appropriate numeric values that will be added to the picture, with 0 at the
  #   end to represent the end of the message
  values <- utf8ToInt(msg)/128
  values <- c(values,0.0)

  if(!is.null(consec)){
    # Vector that contains all positions that have been written to
    check <- startpix
    # PLace the first value at startpix
    pa[startpix] <- values[1]
    # Current pixel
    pixel <- startpix
    for(value in values){
      pixel <- pixel + stride
      count <- 0
      # Avoids index being 0
      pixel <- modifyindex(pixel,pa)
      # Check if current pixel is going to be overwritten
      if (pixel %in% check){
        stop("Overwriting ocurred")
      }
      # Loop until position with no conflicts is found
      while(1){
        # Get position of pixels adjacent to the current pixel
        adjacent <- c(pixel+1,pixel-1,pixel+nrow(pa),pixel-nrow(pa))
        # Avoids an index of 0 (mod is applied across all values in index)
        adjacent <- modifyindex(adjacent,pa)
        # Create a T/F vector based on if positions are in check vector or not
        isadjacent <- adjacent %in% check
        # If the amount of Ts in check vector is less than consec, then no conflicts
        #   (TRUE represents an adjacent pixel that has been written to)
        if(length(isadjacent[isadjacent==TRUE]) <= consec){
          break
        }
        pixel <- pixel + stride
        # Avoids index being 0
        pixel <- modifyindex(pixel,pa)
      }
      # Place value at current pixel, taking wrap around into account
      pa[pixel] <- value
      # Add current pixel position to check vector
      check <- c(check, pixel)
    }
  }

  else{
    # Get indices to write to
    indices <- seq(startpix, length(values)*stride, stride)
    # Avoids indices being 0
    indices <- modifyindex(indices,pa)
    pa[indices] <- values
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
  # Current pixel
  pixel <- startpix
  # Vector to hold all read characters
  message <- intToUtf8(round(pa[startpix]*128))
  # Avoids index being 0
  pixel <- modifyindex(pixel+stride,pa)

  if(is.null(consec)){
    count <- 0
    # Read every 'stride'th pixel, and add it's corresponding utf value to message
    #   until null character is reached (rounding is needed as division is not
    #   always exact)
    while(pa[pixel] != 0){
      message <- c(message, intToUtf8(round(pa[pixel]*128)))
      # Avoids index being 0
      pixel <- modifyindex(pixel+stride,pa)
    }
  }

  else{
    # Vector containing all positions that have been read
    check <- startpix
    count <- 0
    # Loop until null character is encountered
    while(pa[pixel] != 0){
      # Get position of pixels adjacent to the current pixel
      adjacent <- c(pixel+1,pixel-1,pixel+nrow(pa),pixel-nrow(pa))
      # Avoids index being 0
      adjacent <- modifyindex(adjacent,pa)
      # Create a T/F vector based on if positions are in check vector or not
      isadjacent <- adjacent %in% check
      # If the amount of Ts in check vector is less than consec, then no conflicts
      #   (TRUE represents an adjacent pixel that has been written to)
      if(length(isadjacent[isadjacent==TRUE]) <= consec){
        # Read current pixel and add it's corresponding utf value to message
        message <- c(message, intToUtf8(round(pa[pixel]*128)))
        check <- c(check,pixel)
      }
      pixel <- modifyindex(pixel+stride,pa)
    }
  }

  # Combine all read characters into one string
  message <- paste(message,collapse='')
  return(message)
}

startpixel <- 6273
stride1 <- 7163
consec <- 3
teststring <- "This is going to be a realy long sentence to test for any overwriting.
  If any overwriting occurs, the program should stop and you will not see this sentence.
  The file should be very small, so as to maximize the probability of overwriting occurring.
  If you see this paragraph, then the program works."
write.pnm(secretencoder("small_test.pgm",teststring,startpixel,stride1,consec),'small_result.pgm')
print(secretdecoder("small_result.pgm",startpixel,stride1,consec))
