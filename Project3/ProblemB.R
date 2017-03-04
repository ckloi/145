#Problem B
walk <- function(currdir,f,arg,firstcall = TRUE){
  
  
   result <- arg
   
   setwd(currdir)
 
   b <- list.files()
  
   filelist <- character()
  
  for( i in b ) {
    if (dir.exists(i)){
      result <- result + walk(i,f,arg,FALSE)
    }else{
        filelist <- c(filelist, i)
    }
  }
  
   result <- result + f(currdir,filelist,arg)
  
  
  return(result)
}


nfiles <- function(drname,filelist,arg) {
  arg + length(filelist)
}



#find the total number of bytes in all the files.
#this will include the empty space character.
nbyte <- function(drname,filelist,arg){
  #total.bytes <- 0
  for(file in filelist){
    if(!dir.exists(file)){
      file.list <- scan(file, what = "character", quiet = TRUE, sep = '\n')
      for(line in file.list){
        line.list <- strsplit(line, "")[[1]]
        arg <- arg + length(line.list)
      }

    }
  }
}

#remove all the empty directories.
rmemptydirs <- function(drname,filelist,arg){
  
}

print(walk("a",nfiles,0))