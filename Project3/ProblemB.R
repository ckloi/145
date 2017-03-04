#Problem B
walk <- function(currdir, f, arg, firstcall = TRUE) {
  # Keep track of the starting directory
  startdir <- getwd()
  # Switch to the directory specified in the function

  setwd(currdir)

  # Get list of all files
  filelist <- character()

  # For each file in the list...
  for (fi in dir()) {
    if (file.info(fi)$isdir) {
      arg + walk(fi, f, arg, FALSE)
    } else{
      # Otherwise, file is a file, so add it to the file list
      filelist <- c(filelist, fi)
    }
  }

  #call the f function
  arg + f(currdir, filelist, arg)


  # Switch back to starting directory
  setwd(startdir)

  arg + result
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
  arg + total.bytes

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

print(walk("a", nbyte, 0))
