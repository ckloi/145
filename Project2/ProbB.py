import threading
import os

class threadClass(threading.Thread):
    array = []
    def __init__(sByte, eByte):
        thread.Threading.__init__(self)
        self.start = sByte
        self.end = eByte


def linelengths(filenm, ntrh):
    fSize = os.path.getSize(filenm)
    nextByte = 0
    for i in range(ntrh):
        startByte = nextByte
        if i is not ntrh - 1:
            endByte = startByte + (fSize/ntrh)
            nextByte = endByte + 1
        else:
            endByte = fSize - 1

        t = threadClass(startByte, endByte)
        t.start()
