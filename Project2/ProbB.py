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

    lock = threading.Lock()

    def __init__(self,filenm,startbyte,chunksize):
        threading.Thread.__init__(self)
        # Used to store line lengths for each thread
        self.localList = []
        # The number of bytes each thread will read
        self.chunksize = chunksize
        # Byte that thread will start reading at
        self.startB = startbyte
        # The thread id number
        self.myid = threadClass.nextID
        # Increment global id for next thread
        threadClass.nextID += 1
        # File descriptor
        self.fd = open(filenm, 'r')

    def run(self):
        # Have each thread read their entire chunk
        self.fd.seek(self.startB)
        l = self.fd.read(self.chunksize)
        self.fd.close()
        # Check if thread ended with newline or not
        flag = False
        # Remove the end of line character from chunk if it is the last character
        if l[-1] == '\n':
            l = l[:-1]
        # If you get here, the thread ended in the middle of a line
        else:
            flag = True

        # Split chunk by '\n' character, and put the length of each split into
        #   local list.
        self.localList = map(len, l.split('\n'))

        # While it is not this thread's turn to append, sleep
        while threadClass.nextThread != self.myid:
            time.sleep(0)

        # If previous thread ended in the middle of a line, add the first
        #   value of local list to last value of global list(they are
        #   the same line) and remove it from local list.
        threadClass.lock.acquire()
        if threadClass.extraLine:
            threadClass.resultList[-1] += self.localList.pop(0)
        # Append local list contents to global list
        threadClass.resultList.extend(self.localList)
        # Update last thread and set flag variable to appropriate startbyte
        #   based on if the thread stopped in the middle of a line or not
        threadClass.nextThread += 1
        threadClass.extraLine = flag
        threadClass.lock.release()


def linelengths(filenm, ntrh):
    fd = open(filenm, 'r')
    fSize = os.path.getsize(filenm)
    fd.close()
    # Can't have more threads than bytes in file
    if ntrh > fSize or ntrh == 0:
        raise Exception('number of threads is greater than file size or is zero')
    chunksize = fSize / ntrh
    # Used for debugging and join() function
    myThreads = []

    for i in range(ntrh):
        startbyte = i * chunksize
        # If last thread, allocate from start byte to last byte in file
        if i == (ntrh - 1):
            chunksize = fSize - startbyte
        t = threadClass(filenm,startbyte,chunksize)
        myThreads.append(t)
        t.start()

    # Wait for each thread to finish running
    for thr in myThreads:
        thr.join()


    result = threadClass.resultList
    # reset class var
    threadClass.resultList = []
    threadClass.nextID = 0
    threadClass.nextThread = 0
    threadClass.extraLine = False
    return result