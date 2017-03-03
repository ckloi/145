#Project 3
#Problem A
secretencoder <- function(imgfilename,msg,startpix,stride,consec = NULL){
  #if file does nto exist, stop
  if(!file.exists(imgfilename)){ 
    stop("file does not exis")
    }
  #read the file, if not read probably, stop
  #imgfile <- read.pnm(imgfilename) stop("can not load the file")
  imgfile <- read.pnm('LLL.pgm') #stop("can not load the file")
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
  if((ncol(pa) - startpix +1) * nrow(pa) < total.pixs.need){
    stop("not enough space for the message!")
  }
  #now we start to embed the message.
  columnpix <- startpix
  pa.row <- 1
  for(a in str.char.list){
    if(columnpix > ncol(pa)){
      pa.row <- pa.row + 1
    }
    #change the char to the destination pixel
    #print(a)
    pa[pa.row,columnpix] <- utf8ToInt(a) / 128
    columnpix <- columnpix + stride + 1
  }
  
}

