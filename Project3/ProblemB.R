#Problem B

# This function will work similarly to python's os.path.walk(). It will apply
#   function f to all files within directory currdir.

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
    arg + file.info(f)$size
  }

}

#remove all the empty directories.
rmemptydirs <- function(drname, filelist, arg) {
  for(file in filelist){
    if (file.info(file)$isdir){
      setwd(file)
      rmemptydirs(file,dir(),arg)
    }
  }
  if (length(filelist) == 0) {
      setwd("..")
      file.remove(drname)
  }

}

getwd()
print(walk("a", nfiles, 0))
getwd()
print(walk('a',rmemptydirs,0))
