# Initializes file system

import os
import __builtin__


class TextFile:
    def __init__(self, name, startIndex, endIndex):
        self.fileName = name
        # stating position at fsname
        self.byteStart = startIndex
        # ending position at fsname
        self.byteEnd = endIndex  # -1 is undefined
        self.mode = ''
        self.isOpen = False
        # position of the system file/native file
        self.nativeFilePos = startIndex
        # position of the user input/edit file
        self.userFilePos = 0

    def length(self):
        return self.byteEnd - self.byteStart + 1
        # for i in fileLength:

    def seek(self, pos):
        # master file/fsname position moves pos position
        self.nativeFilePos = self.byteStart + pos
        # user file position now is equal pos
        self.userFilePos = pos

    def write(self, content):
        for i in range(len(content)):
            # start write to master/fsname, find the position first
            nativeFD.seek(self.nativeFilePos)
            # write into master/fsname file
            nativeFD.write(content[i])
            # increment the position on both master file and user file
            self.nativeFilePos += 1
            self.userFilePos += 1

    def read(self, rbyte):
        nativeFD.seek(self.nativeFilePos)
        self.nativeFilePos += rbyte
        self.userFilePos += rbyte
        return nativeFD.read(rbyte).translate(None, '\x00')  # exclude the null char

    #haven't tested
    #treat 0xa byte as end of line, not change the pos value
    #Currently returns a list of characters (including \n and null). Needs to return a list of strings
    def readlines(self):
        rstring = ''
        wfile_list = []
        #This is not pos
        nativeFD.seek(self.nativeFilePos)
        for i in range(self.length()):
            if i is '\n':
                break
            else:
                wfile_list.append(nativeFD.read(1).translate(None, '\x00'))
        return wfile_list


    def __str__(self):
        name = '\'' + self.fileName + '\''
        mode = '\'' + self.mode + '\''
        return '<open file {0}, mode {1} at {2}>'.format(name, mode, hex(id(self)))


class Directory:
    def __init__(self):
        self.dirlist = []
        self.files = []


# list to hold file object
fileList = []


def init(fsname):
    # file descriptor of fsname
    global nativeFD
    nativeFD = __builtin__.open(fsname, 'r+w')
    # size of system file
    size = os.path.getsize(fsname)
    print size
    # size = 6
    # list of flag for space availibility of system file fsname
    # 0 for available and 1 for used
    global memory
    # make the flag list have the same size with the master/fsname file
    memory = [0] * size
    # memory = [1,1,0,0,0,1]
    # print(memory[size-1])


# use seek(5) and write to it # check if it has enough space, make a list to keep check the space available

# \xoo is null in python # create set lines to null


# fd = open('abc')

# fd.write
# fd.open

# focus on create file first then directory
# #Creates a file with a size of nbytes
def create(filename, nbytes):
    byteCount = 0
    startIndex = -1
    endIndex = -1

    # find number of consecutive bytes that are available in fsname for the file with nbyte
    for index, byte in enumerate(memory):
        if byte is 0:
            byteCount += 1
        if byteCount is nbytes:
            endIndex = index
            startIndex = index - byteCount + 1
            for i in range(startIndex, endIndex + 1):
                memory[i] = 1
                nativeFD.seek(i)
                nativeFD.write('\x00')  # write null char in file
            break
            # if consecutive available bytes is less thatn nbyte and the following flag is 1
            # set byteCount to 0 and continue the for loop
        elif byteCount is not nbytes and byte is 1:
            byteCount = 0

    # print(memory)

    if startIndex is -1 and endIndex is -1:
        raise Exception('Cannot Create File')
    else:
        f = TextFile(filename, startIndex, endIndex)
        # file.write('\x00')
        fileList.append(f)


# #Opens a file with the given mode
def open(filename, mode):
    for f in fileList:
        # if file object is created before
        if f.fileName is filename:
            f.mode = mode
            f.isOpen = True
            #Set file pointer to beginning of file
            f.seek(0)
            return f
    raise Exception('No such File')


#
# #Closes a certain file
def close(fd):
    fd.isOpen = False
    return fd


#
# #Returns the length (in bytes) of a given file
def length(fd):
    return fd.length()


#
# #Returns the current read/write position in the file
def pos(fd):
    return fd.userFilePos


#
# #Sets the read/write position to pos
def seek(fd, pos):
    if pos >= fd.length():
        raise Exception("Out of bounds")
    fd.seek(pos)


#
# #returns a string; raises an exception if the read would extend beyond the current length of the file
def read(fd, nbytes):
    if not fd.isOpen:
        raise Exception("Failed to read: File is not open.")
    if fd.mode != 'r':
        raise Exception("Failed to read: File is not in read mode.")
    if nbytes > fd.length() - fd.userFilePos:
        raise Exception("Failed to read: Exceeded size of file.")
    return fd.read(nbytes)


#
# #Writes to a file, where writebuf is a string
def write(fd, writebuf):
    if not fd.isOpen:
        raise Exception("Failed to write: File is not open.")
    if fd.mode != 'w':
        raise Exception("Failed to write: File is not in write mode.")
    if len(writebuff) > fd.length() - fd.userFilePos:
        raise Exception("Failed to write: Content exceeds size of file.")
    fd.write(writebuf)

#
# #reads the entire file, returning a list of strings; treats any 0xa byte it encounters as end of a line; does NOT change the pos value
def readlines(fd):
    if not fd.isOpen:
        raise Exception("Failed to read: File is not open.")
    if fd.mode != 'r':
        raise Exception("Failed to read: File is not in read mode.")
    return fd.readlines()
#
# #Deletes a given file
def delfile(filename):
    for index, f in enumerate(fileList):
        # if file object is created before
        if f.fileName is filename:
            for i in range(f.byteStart, f.byteEnd + 1):
                memory[i] = 0
            del fileList[index]
            return
    raise Exception('No such File')

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
