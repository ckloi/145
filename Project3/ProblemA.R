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
        if(length(isadjacent[isadjacent==TRUE]) < consec){
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
  if(is.null(consec)){
    pixel <- pixel + stride
    # Avoids index being 0
    pixel <- modifyindex(pixel,pa)
    # Read every 'stride'th pixel, and add it's corresponding utf value to message
    #   (rounding is needed as division is not always exact)
    while(pa[pixel] != 0){
      message <- c(message, intToUtf8(round(pa[pixel]*128)))
      pixel <- pixel + stride
      # Avoids index being 0
      pixel <- modifyindex(pixel,pa)
    }
  }
  else{
    # Vector containing all positions that have been read
    check <- startpix
    pixel <- pixel + stride
    pixel <- modifyindex(pixel,pa)
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
      if(length(isadjacent[isadjacent==TRUE]) < consec){
        # Read current pixel and add it's corresponding utf value to message
        message <- c(message, intToUtf8(round(pa[pixel]*128)))
      }
      pixel <- pixel + stride
      pixel <- modifyindex(pixel,pa)
    }
  }
  # Combine all read characters into one string
  message <- paste(message,collapse='')
  return(message)
}

startpixel <- 632
stride1 <- 67326
consec <- NULL
write.pnm(secretencoder("LLL.pgm","This sentence should be correct",startpixel,stride1),'LLL1.pgm')
print(secretdecoder("LLL1.pgm",startpixel,stride1))
