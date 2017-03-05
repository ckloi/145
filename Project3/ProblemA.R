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

  imgfile <- read.pnm(imgfilename)

  #extract the pixel array
  pa <- imgfile@grey
  nrow(pa)
  ncol(pa)

  #split the character into a vector
  str.char.list <- strsplit(msg, "")[[1]]

  #need to check if the pixel array have enough space for the message
  #the total number pixels that we need is
  char.num <- length(str.char.list)
  total.pixs.need <- (char.num - 1) * stride + 1

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
        # Check each pixel directly adjacent to current one (diagonals don't count).
        #   Takes all adjacent pixels of current pixel and compares to original
        #   image. If a pixel is written to, it will put FALSE in the corresponding
        #   element of the check matrix.
        checkrow <- pa[c(pa.row+1,pa.row-1),columnpix] == imgfile[c(pa.row+1,pa.row-1),columnpix]
        checkcol <- pa[pa.row, c(columnpix+1,columnpix-1)] == imgfile[pa.row, c(columnpix+1,columnpix-1)]
        adjacent <- length(checkrow[checkrow == FALSE]) + length(checkcol[checkcol == FALSE])

        # Check if current pixel is written to already (TRUE if it is)
        overwrite <- pa[pa.row,columnpix] != imgfile[pa.row,columnpix]

        # Check how many FALSE elements are in the check matrix. This will tell
        #   us how many consecutive pixels surround the current one.
        if (adjacent < consec && !overwrite){
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
