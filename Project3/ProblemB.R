#Problem B
walk <- function(currdir,f,arg,firstcall = TRUE){
  # Keep track of the starting directory
  startdir <- getwd()
  # Switch to the directory specified in the function
  setwd(currdir)
  numbytes <- 0
  # Get list of all files
  files <- file.list(path=".")

  # For each file in the list...
  for(file in files){
    # If file is a directory, recursively call walk (not sure this is implemented correctly)
    if(dir.exists(file)){
      walk(file,f,arg,FALSE)
    }
    # Otherwise, file is a file, so add it to the file list
    else{
      filelist <- c(filelist, file)
    }
  }
  # Add size of all files in file list to running sum (not sure sum is needed,
  #   still don't quite know what arg is)
  sum <- sum + nbytes(currdir,filelist,arg)

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
        #total.bytes <- total.bytes + length(line.list)
        #not sure about this!
        arg + length(line.list)
      }

    }
  }
}

#remove all the empty directories.
rmemptydirs <- function(drname,filelist,arg){
  for(cur.file in filelist){
    if(dir.exists(cur.file)){
      #change to the directory
      setwd(cur.file)
      #and check if there is anything inside the directory
      file.list <- list.files()
      if(length(file.list) == 0){
        #go back to the current directory
        setwd(drname)
        #delect the directory
        file.remove(cur.file)
      }
      #go back to the directory that call the function
      setwd(drname)
    }
  }
}
