# Initializes file system

import os
import __builtin__
import pickle


class TextFile:
    def __init__(self, name, bList):
        self.fileName = name
        # Holds all byte numbers occupied by the file
        self.byteList = bList
        self.bytesUsed = 0
        self.mode = ''
        self.isOpen = False
        # position of the user input/edit file
        self.userFilePos = 0

    def write(self, content):
        for i in range(len(content)):
            # start write to master/fsname, find the position first
            glbl.nativeFD.seek(self.byteList[self.userFilePos])
            # write into master/fsname file
            glbl.nativeFD.write(content[i])
            # Increment the length of the file
            self.bytesUsed += 1
            # increment the position on both master file and user file
            self.userFilePos += 1

    def read(self, rbyte):
        output = ''
        seek(self, rbyte)
        for i in self.byteList[self.userFilePos:rbyte]:
            glbl.nativeFD.seek(i)
            c = glbl.nativeFD.read(1)
            output += c
        return output

    # treat 0xa byte as end of line, not change the pos value
    def readlines(self):
        rstring = ""
        wfile_list = []
        for i in range(self.bytesUsed):
            glbl.nativeFD.seek(self.byteList[i])
            c = glbl.nativeFD.read(1)
            # treat 0xa byte as end of line
            if c == '\n' or c == '0xa':
                # Append current string to List
                if rstring != "":
                    wfile_list.append(rstring)
                # Reset String
                rstring = ""
                continue
            rstring += c
        if rstring != "":
            wfile_list.append(rstring)
        return wfile_list

    def __str__(self):
        name = '\'' + self.fileName + '\''
        mode = '\'' + self.mode + '\''
        return '<open file {0}, mode {1} at {2}>'.format(name, mode, hex(id(self)))


class Directory:
    def __init__(self, name, prevD):
        self.dirName = name
        self.contentList = []
        self.previousDir = prevD


# Global class
class glbl:
    # file descriptor of fsname
    nativeFD = None
    # Used to check if the system is suspended or not
    isActive = False
    # Tracks the number of files currently open
    numFilesOpen = 0
    # Keeps track of available bits
    memory = []
    # Current directory
    curDir = None
    # Root dirctory
    rootDir = None
    # Last file created
    lfc = None
    # Keeps track of how much space is left in the native file
    spaceLeft = 0


def init(fsname):
    glbl.isActive = True
    glbl.numFilesOpen = 0
    glbl.nativeFD = __builtin__.open(fsname, 'r+')
    # size of system file
    size = os.path.getsize(fsname)
    glbl.spaceLeft = size
    # make the flag list have the same size with the master/fsname file
    # 0 for available and 1 for used
    glbl.memory = [0] * size
    # DO NOT SET THIS EQUAL TO ANYTHING ELSE
    glbl.rootDir = Directory('/', None)
    # This will change
    glbl.curDir = glbl.rootDir


def chdir(dirname):
    # Split dirname into list of strings (or directories in this case). Separater character is '/'
    dirList = dirname.split('/')
    # If '' is last element, that means that '/' is the last character in the path and can be ignored
    if dirList[-1] == '':
        del dirList[-1]
    for dr in dirList:
        # If first character in dirname is '/', the first string will be blank
        if dr == '':
            glbl.curDir = glbl.rootDir
            continue
        # '.' means current directory, so just move onto the next dir in the list
        if dr == '.':
            continue
        # '..' means previous directory, so change curDir to previousDir, and resume
        if dr == '..':
            glbl.curDir = glbl.curDir.previousDir
            continue
        # Otherwise, go through the list trying to find the right directory
        glbl.curDir = find(dr, 'd')[1]


# return a list
# list[0] = index list[1] = object
def find(name, searchType):
    if searchType is 'd':  # Directory
        for index, d in enumerate(glbl.curDir.contentList):
            if isinstance(d, Directory) and d.dirName == name:
                return [index, d]
    elif searchType is 'f':  # file
        for index, f in enumerate(glbl.curDir.contentList):
            if isinstance(f, TextFile) and f.fileName == name:
                return [index, f]
    raise Exception('No such file or directory: ' + name)


# travel to the directory that the user specified
# return the file or directory name of the destination
def travel(path):
    fPath = path.split('/')
    fPath = filter(lambda x: x != '', fPath)
    # Last string in list should be file name to be created
    name = fPath[-1]
    # If only one element in the list, then only argument is file name, so no
    # need to change directories
    if len(fPath) > 1:
        # Join all strings except last (the directories) with '/' character so that
        # a path is passed into chdir
        fDir = "/".join(fPath[0:-1])
        if path[0] == '/':
            fDir = '/' + fDir
        chdir(fDir)
    elif path[0] == '/':
        chdir('/')
    return name


# focus on create file first then directory
# #Creates a file with a size of nbytes
def create(filename, nbytes):
    # If there's no space, raise exception
    if nbytes > glbl.spaceLeft:
        raise Exception("Cannot create file: Not enough space")

    tempDir = glbl.curDir
    fn = travel(filename)
    try:
        find(fn, 'f')
    except:
        byteCount = 0
        bList = []

        # If lfc is none, then no files are created yet, so just find consecutive space
        if glbl.lfc is None:
            for index, byte in enumerate(glbl.memory):
                if byte is 0:
                    byteCount += 1
                    bList.append(index)
                if byteCount is nbytes:
                    for i in bList:
                        glbl.memory[i] = 1
                        glbl.nativeFD.seek(i)
                        glbl.nativeFD.write('\x00')
                        glbl.spaceLeft -= 1
                    break
                elif byteCount is not nbytes and byte is 1:
                    byteCount = 0
            f = TextFile(fn, bList)
            glbl.curDir.contentList.append(f)
            glbl.lfc = f
            glbl.curDir = tempDir
            return

        # Otherwise, loop from last created byte
        startIndex = glbl.lfc.byteList[-1]
        for index, byte in enumerate(glbl.memory[startIndex:]):
            if byte is 0:
                byteCount += 1
                bList.append(startIndex + index)
            if byteCount is nbytes:
                for i in bList:
                    glbl.memory[i] = 1
                    glbl.nativeFD.seek(i)
                    glbl.nativeFD.write('\x00')
                    glbl.spaceLeft -= 1
                break

        # If finished above loop and nbytes have not been allocated, start from beginning
        if byteCount < nbytes:
            for index, byte in enumerate(glbl.memory[:startIndex]):
                if byte is 0:
                    byteCount += 1
                    bList.append(index)
                if byteCount is nbytes:
                    for i in bList:
                        glbl.memory[i] = 1
                        glbl.nativeFD.seek(i)
                        glbl.nativeFD.write('\x00')
                        glbl.spaceLeft -= 1
                    break

        byteCount = 0
        f = TextFile(fn, bList)
        glbl.curDir.contentList.append(f)
        glbl.lfc = f
        glbl.curDir = tempDir
        return


# Opens a file with the given mode
def open(filename, mode):
    # If file system is suspended, can't open file
    if not glbl.isActive:
        raise Exception("Cannot open file: file system is currently suspended")

    tempDir = glbl.curDir

    fn = travel(filename)

    f = find(fn, 'f')[1]
    f.mode = mode
    # Only increment if a non-opened file is being opened
    if not f.isOpen:
        glbl.numFilesOpen += 1
    f.isOpen = True
    # Set file pointer to beginning of file
    f.userFilePos = 0
    glbl.curDir = tempDir
    return f


# Closes a certain file
def close(fd):
    # Only decrement if an open file is being closed
    if fd.isOpen:
        glbl.numFilesOpen -= 1
    fd.isOpen = False
    return fd


# Returns the length of used bytes in the file
def length(fd):
    return fd.bytesUsed


# Returns the current read/write position in the file
def pos(fd):
    return fd.userFilePos


# Sets the read/write position to pos
def seek(fd, pos):
    if pos >= fd.bytesUsed:
        raise Exception("Out of bounds")
    fd.userFilePos = pos


# returns a string; raises an exception if the read would extend beyond the current length of the file
def read(fd, nbytes):
    if not fd.isOpen:
        raise Exception("Failed to read: File is not open.")
    if fd.mode != 'r':
        raise Exception("Failed to read: File is not in read mode.")
    if nbytes > len(fd.byteList[fd.userFilePos:]):
        raise Exception("Failed to read: Exceeded size of file.")
    return fd.read(nbytes)


# Writes to a file, where writebuf is a string
def write(fd, writebuf):
    if not fd.isOpen:
        raise Exception("Failed to write: File is not open.")
    if fd.mode != 'w':
        raise Exception("Failed to write: File is not in write mode.")
    if len(writebuf) > len(fd.byteList[fd.userFilePos:]):
        raise Exception("Failed to write: Content exceeds size of file.")
    fd.write(writebuf)


# reads the entire file, returning a list of strings; treats any 0xa byte it
# encounters as end of a line; does NOT change the pos value
def readlines(fd):
    if not fd.isOpen:
        raise Exception("Failed to read: File is not open.")
    if fd.mode != 'r':
        raise Exception("Failed to read: File is not in read mode.")
    return fd.readlines()


# Deletes a given file
def delfile(filename):
    tempDir = glbl.curDir

    fn = travel(filename)

    temp = find(fn, 'f')
    index = temp[0]
    f = temp[1]
    if f.isOpen:
        glbl.curDir = tempDir
        raise Exception("Unable to delete file: File is open.")
    for i in f.byteList:
        glbl.memory[i] = 0
        glbl.spaceLeft += 1
    del glbl.curDir.contentList[index]
    glbl.curDir = tempDir


# Creates a directory named "dirname"
def mkdir(dirname):
    tempDir = glbl.curDir

    dn = travel(dirname)

    try:
        find(dn, 'd')
    except:
        glbl.curDir.contentList.append(Directory(dn, glbl.curDir))  # no duplicate dirname
        glbl.curDir = tempDir
        return
    glbl.curDir = tempDir
    raise Exception("Already created " + dn + " directory")


# Deletes a given directory
def deldir(dirname):
    tempDir = glbl.curDir

    dn = travel(dirname)

    temp = find(dn, 'd')
    index = temp[0]
    if temp[1] == tempDir:
        glbl.curDir = tempDir
        raise Exception("Cannot delete directory: Currently in directory to be deleted")
    # Temporarily change into directory to be deleted and delete everything in there
    chdir(dn)
    while glbl.curDir.contentList:
        i = glbl.curDir.contentList[0]
        if isinstance(i, TextFile):
            delfile(i.fileName)
        if isinstance(i, Directory):
            deldir(i.dirName)
    chdir('..')

    del glbl.curDir.contentList[index]
    glbl.curDir = tempDir


# Returns true if "dirname" is a directory, false otherwise
def isdir(dirname):
    tempDir = glbl.curDir  # save curDir ref
    try:
        chdir(dirname)  # change dirname
        found = True
    except:
        found = False
    glbl.curDir = tempDir
    return found


# FOR TESTING
def getcwd():
    return glbl.curDir.dirName


# Lists all files in directory "dirname"
def listdir(dirname):
    # Save current directory object
    tempDir = glbl.curDir
    chdir(dirname)

    fileList = []
    # Place all file/directory names in a list
    for inst in glbl.curDir.contentList:
        if isinstance(inst, TextFile):
            fileList.append(inst.fileName)
        elif isinstance(inst, Directory):
            fileList.append(inst.dirName)
    fileList.sort()
    # Restore current directory object
    glbl.curDir = tempDir
    return fileList


# Suspends the current file system
def suspend():
    # If any files are still open, cannot suspend file system
    if glbl.numFilesOpen != 0:
        raise Exception("Cannot suspend file system: a file is still open.")

    saveName = glbl.nativeFD.name + '.fssave'
    glbl.isActive = False
    saveDict = {"memory": glbl.memory, "rootDir": glbl.rootDir, "curDir": glbl.curDir, "fsname": glbl.nativeFD.name}
    pickle_file = __builtin__.open(saveName, 'wb')
    pickle.dump(saveDict, pickle_file)
    glbl.nativeFD.close()  # close the master file
    pickle_file.close()


# #Resumes the previously suspended file system
def resume(fname):
    # Check if the file system is suspended
    if glbl.isActive:
        raise Exception("No file system has been suspended")

    pickle_file = __builtin__.open(fname, 'rb')
    saveDict = pickle.load(pickle_file)
    glbl.isActive = True
    glbl.nativeFD = __builtin__.open(saveDict["fsname"], 'r+')
    glbl.memory = saveDict["memory"]
    glbl.rootDir = saveDict["rootDir"]
    glbl.curDir = saveDict["curDir"]
    pickle_file.close()
