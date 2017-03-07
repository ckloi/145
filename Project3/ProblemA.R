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

  if(stride > file.size(imgfilename)){
    warning("Stride is larger than the size of the file")
  }
  #read the file, if not read probably, stop

  imgfile <- read.pnm(imgfilename)

  #extract the pixel array
  pa <- imgfile@grey
  # Duplicate to check for consecutive pixels and overwrite
  original <- imgfile@grey

  #split the character into a vector
  str.char.list <- strsplit(msg, "")[[1]]

  #need to check if the pixel array have enough space for the message
  #the total number pixels that we need is
  char.num <- length(str.char.list)
  total.pixs.need <- (char.num - 1) * stride + 1

  values <- utf8ToInt(msg)/128
  values <- c(values,0.0)

  # if((ncol(pa) - startpix +1) * nrow(pa) < total.pixs.need){
  #   stop("Not enough space for the message!")
  # }

  #now we start to embed the message.

  # Check for adjacent pixels by comparing changed picture with original
  #   (only if consec is not NULL)

  if(!is.null(consec)){
    check <- startpix
    pa[startpix] <- values[1]
    pixel <- startpix
    for(value in values){
      pixel <- pixel + stride
      if (original[pixel] != pa[pixel]){
        stop("Overwriting ocurred")
      }
      # Loop until position with no conflicts is found
      while(1){
        # Get position of pixels adjacent to the current pixel
        adjacent <- c(pixel+1,pixel-1,pixel+nrow(pa),pixel-nrow(pa)) %% length(pa)
        # Create a T/F vector based on if positions are in check vector or not
        isadjacent <- adjacent %in% check
        # If the amount of Ts in check vector is less than consec, then no conflicts
        if(length(isadjacent[isadjacent==TRUE]) < consec){
          break
        }
        pixel <- pixel + stride
      }
      # Place value at current pixel, taking wrap around into account
      pa[pixel %% length(pa)] <- value
      # Add current pixel position to check vector
      check <- c(check, pixel)
    }
  }

  else{
    pa[seq(startpix, length(values)*stride, stride) %% length(pa)] <- values
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

  pixel <- startpix
  message <- intToUtf8(round(pa[startpix]*128))
  if(is.null(consec)){
    while(pa[(pixel+stride) %% length(pa)] != 0){
      message <- c(message, intToUtf8(round(pa[pixel <- pixel+stride %% length(pa)]*128)))
    }
  }
  else{
    check <- startpix
    while(pa[pixel + stride %% lenth(pa)] != 0){

    }
  }
  message <- paste(message,collapse='')
  return(message)
}

startpixel <- 2
stride1 <- 400
consec <- NULL
write.pnm(secretencoder("LLL.pgm","ABCDEFGHIJKLMNOPQRSTUVWXYZ",startpixel,stride1),'LLL1.pgm')
print(secretdecoder("LLL1.pgm",startpixel,stride1))
