import os

#Initializes file system
def init(fsname):
    
#Creates a file with a size of nbytes
def create(filename, nbytes):
    
#Opens a file with the given mode
def open(filename, mode):
    
#Closes a certain file
def close(fd):
    
#Returns the length (in bytes) of a given file
def length(fd):
    
#Returns the current read/write position in the file    
def pos(fd):
    
#Sets the read/write position to pos
def seek(fd, pos):
    
#returns a string; raises an exception if the read would extend beyond the current length of the file
def read(fd, nbtes):
    
#Writes to a file, where writebuf is a string
def write(fd, writebuf):
    
#reads the entire file, returning a list of strings; treats any 0xa byte it encounters as end of a line; does NOT change the pos value
def readlines(fd):
    
#Deletes a given file
def delfile(filename):
    
#Creates a directory named "dirname"
def mkdir(dirname):
    
#Deletes a given directory
def deldir(dirname):
    
#Returns true if "dirname" is a directory, false otherwise
def isdir(dirname):
    
#Lists all files in directory "dirname"
def listdir(dirname):
    
#Suspends the current file system
def suspend():
    
#Resumes the previously suspended file system
def resume():
