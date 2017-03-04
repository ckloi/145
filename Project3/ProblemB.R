#Problem B
walk <- function(currdir, f, arg, firstcall = TRUE) {
  # Keep track of the starting directory
  startdir <- getwd()
  # Switch to the directory specified in the function
  
  setwd(currdir)
  
  result <- arg
  
  b <- list.files()
  
  # Get list of all files
  filelist <- character()
  
  # For each file in the list...
  for (file in filelist) {
    if (dir.exists(i)) {
      result <- result + walk(i, f, arg, FALSE)
    } else{
      # Otherwise, file is a file, so add it to the file list
      filelist <- c(filelist, file)
    }
  }
  
  #call the f function 
  result <- result + f(currdir, filelist, arg)
  
  
  # Switch back to starting directory
  setwd(startdir)
  
  return (result)
}

nfiles <- function(drname, filelist, arg) {
  arg + length(filelist)
}


#find the total number of bytes in all the files.
#this will include the empty space character.
nbyte <- function(drname, filelist, arg) {
  #total.bytes <- 0
  for (file in filelist) {
    if (!dir.exists(file)) {
      file.list <-
        scan(file,
             what = "character",
             quiet = TRUE,
             sep = '\n')
      for (line in file.list) {
        line.list <- strsplit(line, "")[[1]]
        #total.bytes <- total.bytes + length(line.list)
        #not sure about this!
        arg + length(line.list)
      }
      
    }
  }
}

#remove all the empty directories.
rmemptydirs <- function(drname, filelist, arg) {

  for (cur.file in filelist) {
    if (dir.exists(cur.file)) {
      #change to the directory
      setwd(cur.file)
      #and check if there is anything inside the directory
      file.list <- list.files()
      if (length(file.list) == 0) {
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

print(walk("a", nfiles, 0))

