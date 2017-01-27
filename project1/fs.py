
#Initializes file system

import os

class TextFile:
    def __init__(self,name,startIndex,endIndex):
        self.fileName = name
        self.byteStart = startIndex
        self.byteEnd  = endIndex  # -1 is undefined
        self.isOpen = False
    def content(self):
        fileLength = self.byteEnd - self.byteStart +1
        #for i in fileLength:
    def write(self,str):
        for i in range(self.byteStart, self.byteEnd + 1):
            fd.seek(i)
            memory[i] = 1
            fd.write(str)





class Directory:
    def __init__(self):
        self.dirlist = []
        self.files = []




fd = None
memory = []



def init(fsname):
    global fd
    fd = open(fsname,'r+w')
    size = os.path.getsize(fsname)
    print size
    #size = 6
    global memory
    memory = [0] * size
    #memory = [1,1,0,0,0,1]
    #print(memory[size-1])


#use seek(5) and write to it # check if it has enough space, make a list to keep check the space available

#\xoo is null in python # create set lines to null


#fd = open('abc')

#fd.write
#fd.open

# focus on create file first then directory
# #Creates a file with a size of nbytes
def create(filename, nbytes):
    byteCount = 0
    startIndex = -1
    endIndex = -1


    for index, byte in enumerate(memory):
        if byte is 0:
            byteCount = byteCount + 1
        if byteCount is nbytes:
            endIndex = index
            startIndex = index - byteCount + 1
            break
        elif byteCount is not nbytes and byte is 1:
            byteCount = 0

    #print(memory)

    if (startIndex is -1 and endIndex is -1):
        print("Cannot Create File")
    else:
        file = TextFile(filename,startIndex,endIndex)
        file.write('\x00')

# #Opens a file with the given mode
# def open(filename, mode):
#
# #Closes a certain file
# def close(fd):
#
# #Returns the length (in bytes) of a given file
# def length(fd):
#
# #Returns the current read/write position in the file
# def pos(fd):
#
# #Sets the read/write position to pos
# def seek(fd, pos):
#
# #returns a string; raises an exception if the read would extend beyond the current length of the file
# def read(fd, nbtes):
#
# #Writes to a file, where writebuf is a string
# def write(fd, writebuf):
#
# #reads the entire file, returning a list of strings; treats any 0xa byte it encounters as end of a line; does NOT change the pos value
# def readlines(fd):
#
# #Deletes a given file
# def delfile(filename):
#
# #Creates a directory named "dirname"
# def mkdir(dirname):
#
# #Deletes a given directory
# def deldir(dirname):
#
# #Returns true if "dirname" is a directory, false otherwise
# def isdir(dirname):
#
# #Lists all files in directory "dirname"
# def listdir(dirname):
#
# #Suspends the current file system
# def suspend():
#
# #Resumes the previously suspended file system
# def resume():
