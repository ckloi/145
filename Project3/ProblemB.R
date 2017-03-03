#Problem B
walk <- function(currdir,f,arg,firstcall = TRUE){}

#find the total number of bytes in all the files.
#this will include the empty space character.
nbyte <- function(drname,filelist,arg){
  total.bytes <- 0
  for(file in filelist){
    if(!dir.exists(file)){
      file.list <- scan(file, what = "character", quiet = TRUE, sep = '\n')
      for(line in file.list){
        line.list <- strsplit(line, "")[[1]]
        total.bytes <- total.bytes + length(line.list)
      }

    }
  }
}

#remove all the empty directories.
rmemptydirs <- function(drname,filelist,arg){}