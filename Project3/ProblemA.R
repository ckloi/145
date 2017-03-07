#Project 3
#Problem A

# This program will embed a secret message into a picture, allowing for no more
# than 'consec' adjacent pixels to be changed

library(pixmap)

printf <- function(...)print(sprintf(...))


secretencoder <- function(imgfilename,msg,startpix,stride,consec = NULL){
  #if file does nto exist, stop
  if(!file.exists(imgfilename)){
    stop("File does not exist")
  }

  imgfile <- read.pnm(imgfilename)

  #extract the pixel array
  pa <- imgfile@grey
  # Duplicate to check for consecutive pixels and overwrite
  original <- imgfile@grey

  if(stride%%length(pa) != any(c(stride,0))){
    warning("Stride is not relatively prime to image size")
  }
  #read the file, if not read probably, stop

  #split the character into a vector
  str.char.list <- strsplit(msg, "")[[1]]

  #need to check if the pixel array have enough space for the message
  #the total number pixels that we need is
  char.num <- length(str.char.list)
  total.pixs.need <- (char.num - 1) * stride + 1

  # Appropriate numeric values that will be added to the picture, with 0 at the
  #   end to represent the end of the message
  values <- utf8ToInt(msg)/128
  values <- c(values,0.0)

  # if((ncol(pa) - startpix +1) * nrow(pa) < total.pixs.need){
  #   stop("Not enough space for the message!")
  # }

  #now we start to embed the message.

  # Check for adjacent pixels by comparing changed picture with original
  #   (only if consec is not NULL)

  if(!is.null(consec)){
    # Vector that contains all positions that have been written to
    check <- startpix
    # PLace the first value at startpix
    pa[startpix] <- values[1]
    # Current pixel
    pixel <- startpix
    for(value in values){
      pixel <- pixel + stride
      # Check if current pixel is going to be overwritten
      if (original[pixel] != pa[pixel]){
        stop("Overwriting ocurred")
      }
      # Loop until position with no conflicts is found
      while(1){
        # Get position of pixels adjacent to the current pixel
        adjacent <- c(pixel+1,pixel-1,pixel+nrow(pa),pixel-nrow(pa)) %% length(pa)
        # Avoids an index of 0 (mod is applied across all values in index)
        adjacent <- ifelse(adjacent%%length(pa),adjacent%%length(pa),length(pa))
        # Create a T/F vector based on if positions are in check vector or not
        isadjacent <- adjacent %in% check
        # If the amount of Ts in check vector is less than consec, then no conflicts
        #   (TRUE represents an adjacent pixel that has been written to)
        if(length(isadjacent[isadjacent==TRUE]) < consec){
          break
        }
        pixel <- pixel + stride
      }
      index <- ifelse(pixel%%length(pa),pixel%%length(pa),length(pa))
      # Place value at current pixel, taking wrap around into account
      pa[index] <- value
      # Add current pixel position to check vector
      check <- c(check, pixel)
    }
  }

  else{
    # Get indices to write to
    indices <- seq(startpix, length(values)*stride, stride)
    # Avoids indices being 0
    indices <- ifelse(indices%%length(pa),indices%%length(pa),length(pa))
    pa[indices] <- values
  }
  result <- imgfile
  result@grey <- pa
  print(length(pa))
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
  if(is.null(consec)){
    # Read every 'stride'th pixel, and add it's corresponding utf value to message
    #   (rounding is needed as division is not always exact)
    while(pa[(pixel+stride) %% length(pa)] != 0){
      pixel <- pixel + stride
      # Avoids index being 0
      index <- ifelse(pixel%%length(pa),pixel%%length(pa),length(pa))
      message <- c(message, intToUtf8(round(pa[index]*128)))
    }
  }
  else{
    # Vector containing all positions that have been read
    check <- startpix
    pixel <- pixel + stride
    # Loop until null character is encountered
    while(pa[pixel %% length(pa)] != 0){
      # Get position of pixels adjacent to the current pixel
      adjacent <- c(pixel+1,pixel-1,pixel+nrow(pa),pixel-nrow(pa))
      # Avoids index being 0
      adjacent <- ifelse(adjacent%%length(pa),adjacent%%length(pa),length(pa))
      # Create a T/F vector based on if positions are in check vector or not
      isadjacent <- adjacent %in% check
      # If the amount of Ts in check vector is less than consec, then no conflicts
      #   (TRUE represents an adjacent pixel that has been written to)
      if(length(isadjacent[isadjacent==TRUE]) < consec){
        # Avoids index being 0
        index <- ifelse(pixel%%length(pa),pixel%%length(pa),length(pa))
        # Read current pixel and add it's corresponding utf value to message
        message <- c(message, intToUtf8(round(pa[index]*128)))
      }
      pixel <- pixel + stride
    }
  }
  # Combine all read characters into one string
  message <- paste(message,collapse='')
  return(message)
}

startpixel <- 2
stride1 <- 2
consec <- NULL
write.pnm(secretencoder("LLL.pgm","This sentence should be correct",startpixel,stride1),'LLL1.pgm',3)
print(secretdecoder("LLL1.pgm",startpixel,stride1,3))
