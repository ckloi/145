#Problem B

# This function will work similarly to python's os.path.walk(). It will take in a
#   directory to read, a user defined function, and the function's argument as
#   parameters. The result will be the total size of the directory.

walk <- function(currdir, f, arg, firstcall = TRUE) {
  # Keep track of the starting directory
  startdir <- getwd()
  # Switch to the directory specified in the function

  setwd(currdir)

  result <- 0

  # Get list of all files
  filelist <- character()

  # For each file in the list...
  for (fi in dir()) {
    if (file.info(fi)$isdir) {
      result <- result + walk(fi, f, arg, FALSE)
    }

    else{
      # Otherwise, file is a file, so add it to the file list
      filelist <- c(filelist, fi)
    }
  }

  #call the f function
  result <- result + f(currdir, filelist, arg)


  # Switch back to starting directory
  setwd(startdir)

  return(result)
}

nfiles <- function(drname, filelist, arg) {
  arg + length(filelist)
}


#find the total number of bytes in all the files.
#this will include the empty space character.
nbyte <- function(drname, filelist, arg) {
  total.bytes <- 0

  for (f in filelist) {
    total.bytes <- total.bytes  + file.info(f)$size
  }
  return(total.bytes)

}

#remove all the empty directories.
rmemptydirs <- function(drname, filelist, arg) {
  
  if (length(filelist) == 0) {
      setwd("..")
      file.remove(drname)
  }
  
  
}

print(walk("a", rmemptydirs, 0))
