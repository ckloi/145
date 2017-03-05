#Project 3
#Problem A


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

  imgfile <- read.pnm(imgfilename) #stop("can not load the file")
  #imgfile <- read.pnm('LLL.pgm') #stop("can not load the file")

  #extract the pixel array
  pa <- imgfile@grey
  nrow(pa)
  ncol(pa)

  #split the character into a vector
  #those are for testing
  #startpix <- 60
  #stride <- 5
  #msg <- "this is a test message"
  str.char.list <- strsplit(msg, "")[[1]]

  #need to check if the pixel array have enough space for the message
  #the total number pixels that we need is
  char.num <- length(str.char.list)
  total.pixs.need <- (char.num - 1) * (stride + 1) + 1

  # Stop if the number of pixels in the picture is larger than the message

  if((ncol(pa) - startpix +1) * nrow(pa) < total.pixs.need){
    stop("Not enough space for the message!")
  }

  # We only need to check for consectutive bits if consec is not NULL
  # Otherwise, we check for consec number of consecutive bits

  #now we start to embed the message.
  columnpix <- startpix
  pa.row <- 1
  for(a in str.char.list){
    if(pa.row > nrow(pa)){
      columnpix <- columnpix + 1
      pa.row <- pa.row - nrow(pa)
    }
    #change the char to the destination pixel
    #print(a)
    printf("index is [%d,%d]",pa.row,columnpix)
    # Check for adjacent pixels by comparing changed picture with original
    #   (only if consec is not NULL)

    if(!is.null(consec)){
      # As long as adjacent >= consec, you must keep moving until you find a
      #   spot that has < consec adjacent pixels.
      while(1){
        adjacent <- 0
        # Check each pixel directly adjacent to current one (diagonals don't count)
        if (pa[pa.row-1,columnpix] != imgfile[pa.row-1,columnpix]){
          adjacent <- adjacent + 1
        }
        if (pa[pa.row+1,columnpix] != imgfile[pa.row+1,columnpix]){
          adjacent <- adjacent + 1
        }
        if(pa[pa.row,columnpix-1] != imgfile[pa.row,columnpix-1]){
          adjacent <- adjacent + 1
        }
        if(pa[pa.row,columnpix+1] != imgfile[pa.row,columnpix+1]){
          adjacent <- adjacent + 1
        }
        # If there are not consec number of adjacent pixels, break
        if(adjacent < consec){
          break
        }
        # Otherwise, move stride pixels further
        pa.row <- pa.row + stride
        if(pa.row > nrow(pa)){
          columnpix <- columnpix + 1
          pa.row <- pa.row - nrow(pa)
        }
      }
    }

    pa[pa.row,columnpix] <- utf8ToInt(a) / 128

    print(pa[pa.row,columnpix])
    pa.row <- pa.row + stride
  }
  View(pa)
  result <- imgfile
  result@grey <- pa
  return(result)

}

secretencoder("LLL.pgm","hello",2,400)
