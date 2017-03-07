#Project 3
#Problem A

# This program will embed a secret message into a picture, allowing for no more
# than 'consec' adjacent pixels to be changed

library(pixmap)


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

  if(length(pa)%%stride == 0){
    warning("Stride is not relatively prime to image size. Overwriting may occur.")
  }
  #this length of a string will be 1, length(msg) will not work! 
  if(nchar(msg) > length(pa)){
    stop("Not enough space for the message.")
  }

  # Appropriate numeric values that will be added to the picture, with 0 at the
  #   end to represent the end of the message, convert msg to a vector of number.
  values <- utf8ToInt(msg)/128
  values <- c(values,0.0)

  if(is.null(consec)){
    # Get indices to write to
    indices <- seq(startpix, length(values)*stride, stride)
    # Avoids indices being 0
    indices <- modifyindex(indices,pa)
    pa[indices] <- values
  }

  else {
    # Vector that contains all positions that have been written to
    check <- startpix
    # PLace the first value at startpix
    pa[startpix] <- values[1]
    # Current pixel
    pixel <- startpix
    # Place rest of values in appropriate positions
    for(value in values[2:length(values)]){
      # Avoids index being 0
      pixel <- modifyindex(pixel+stride,pa)

      # First pixel to start checking conflicts at
      firstcheck <- pixel

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
          # If pixel will not be overwritten, break
          if (!(pixel %in% check)){
            break
          }
        }
        # Avoids index being 0
        pixel <- modifyindex(pixel+stride,pa)

        if(pixel == firstcheck){
          # If you are here, you have gone through the entire image without writing
          #   anything, and will continue to do so endlessly, so stop.
          stop("Endless conflicts")
        }
      }

      # Place value at current pixel, taking wrap around into account
      pa[pixel] <- value
      # Add current pixel position to check vector
      check <- c(check, pixel)
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
  # Current pixel
  pixel <- startpix
  # Vector to hold all read characters
  message <- intToUtf8(round(pa[startpix]*128))
  # Avoids index being 0
  pixel <- modifyindex(pixel+stride,pa)

  if(is.null(consec)){
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
      adjacent <- c(pixel+1, pixel-1, pixel+nrow(pa), pixel-nrow(pa))
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

# This function allows for wrap-around of matrix 'mat' and stops index from being 0
#   (since result of mod could be 0, and R starts at 1 for indices)
modifyindex <- function(index,mat){
  # index %% langth(mat) will always get index, i don't know if this what you want?
  return(ifelse(length(mat)%%index,index%%length(mat),length(mat)))
}

startpixel <- 60000
stride1 <- 513
consec <- 3
teststring <- "This is going to be a realy long sentence to test for any overwriting.
  If any overwriting occurs, the program should stop and you will not see this sentence.
  The file should be very small, so as to maximize the probability of overwriting occurring.
  If you see this paragraph, then the program works. Making this longer in hopes of overwrite.
  Like Reaaaaaaaaallllllllllllyyyyyyyyyyyyyy llllllloooooooooonnnnnnnnngggggggggg. So Long.
  This will probably be the longest test string you've ever read. This is going to be longer
  than a 152A lecture with Mukherjee. Yes, it's that long. That class is so boring. There
  still isn't an overwrite yet. Wtf. Consec isn't null either. Crazy. I'll have to change the
  values around. Still nothing. How long does this have to be to get an error? Like,for real.
  I don't even know what to type anymore. I didn't thing the string would have to be this long
  just to get a conflict. I might just have to resort to printing out a bunch of the same
  character. Didn't think i'd have to write a novel for this. Still going. The picture is 256x256,
  so rip this test string. Has to be like 60,000 characters in order to do anything. This is maybe
  like a few hundred. Ok screw it. Here goes. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
  cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
  cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
  ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
  ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd.
  FINALLY!"
write.pnm(secretencoder("small_test.pgm",teststring,startpixel,stride1,consec),'small_result.pgm')
print(secretdecoder("small_result.pgm",startpixel,stride1,consec))
