import threading
import os
import time

class threadClass(threading.Thread):
    # Global line length list
    resultList = []
    # Next id that will be assigned to a thread
    nextID = 0
    # Next thread id that will be appended to global list
    nextThread = 0
    # Flag to check if thread ended in the middle of a line
    extraLine = False
    # Thread lock
    extraLineLock = threading.Lock()
    flagLock = threading.Lock()
    def __init__(self,fd,chunksize):
        threading.Thread.__init__(self)
        # Used to store line lengths for each thread
        self.localList = []
        # The number of bytes each thread will read
        self.chunksize = chunksize
        # The thread id number
        self.myid = threadClass.nextID
        # Increment global id for next thread
        threadClass.nextID += 1
        # File descriptor
        self.fd = fd

    def run(self):
        # Have each thread read their entire chunk
        l = self.fd.read(self.chunksize)
        # Check if thread ended with newline or not
        threadClass.flagLock.acquire()
        flag = False
        # Remove the end of line character from chunk if it is the last character
        if l.endswith('\n'):
            l = l[:-1]
        # If you get here, the thread ended in the middle of a line
        else:
            flag = True
        threadClass.flagLock.release()

        # Split chunk by '\n' character, and put the length of each split into
        #   local list.
        self.localList = map(lambda x: len(x),l.split('\n'))
        # Append list contents to end of global list
        while 1:
            if threadClass.nextThread == self.myid:
                # If previous thread ended in the middle of a line, add the first
                #   value of local list to last value of global list(they are
                #   the same line) and remove it from local list.
                if threadClass.extraLine:
                    threadClass.resultList[-1] += self.localList.pop(0)
                # Append local list contents to global list
                threadClass.resultList.extend(self.localList)
                # Update last thread and set flag variable to appropriate startbyte
                #   based on if the thread stopped in the middle of a line or not
                threadClass.extraLineLock.acquire()
                threadClass.nextThread += 1
                threadClass.extraLine = flag
                threadClass.extraLineLock.release()
                break
            # If it is not this thread's turn to append to global list, give up turn
            else:
                time.sleep(0)




def linelengths(filenm, ntrh):
    fd = open(filenm)
    fSize = os.path.getsize(filenm)
    # Can't have more threads than bytes in file
    if ntrh > fSize:
        raise Exception('number of threads is greater than file size')
    chunksize = fSize / ntrh
    # Used for debugging and join() function
    myThreads = []

    for i in range(ntrh):
        startbyte = i * chunksize
        # If last thread, allocate from start byte to last byte in file
        if i == (ntrh - 1):
            chunksize = fSize - startbyte
        t = threadClass(fd,chunksize)
        myThreads.append(t)
        t.start()

    # Wait for each thread to finish running
    for t in myThreads:
        t.join()

    return threadClass.resultList
