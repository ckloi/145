import threading
import os
import random
import time

class threasdClass(threading.Thread):
    resultList = []
    id = 0
    lastThread = 0
    extraLine = False
    def __init__(self,sByte, eByte,fd):
        threading.Thread.__init__(self)
        self.localList = []
        self.start = sByte
        self.end = eByte
        self.myid = threasdClass.id
        threasdClass.id += 1
        self.fd = fd

    def run(self):
        self.fd.seek(self.start)
        l = self.fd.read(self.end - self.start + 1)
        # check end of line
        flag = False
        if l.endswith('\n'):
            l = l[:-1]
        # if data is splitted into two chunk
        else:
            flag = True

        self.localList = map(lambda x: len(x),l.split('\n'))
        #if threasdClass.lastThread == self.myid:
        if threasdClass.extraLine:
            threasdClass.resultList[-1] += self.localList.pop(0)
        threasdClass.resultList.extend(self.localList)
        threasdClass.lastThread += 1
        if flag:
            threasdClass.extraLine = True
        else:
            threasdClass.extraLine = False




def linelengths(filenm, ntrh):
    fd = open(filenm)
    fSize = os.path.getsize(filenm)
    nextByte = 0

    for i in range(ntrh):
        startByte = nextByte
        if i is not ntrh - 1:
            endByte = startByte + (fSize/ntrh)
            nextByte = endByte + 1
        else:
            endByte = fSize - 1
        t = threasdClass(startByte,endByte,fd)
        t.run()
    return threasdClass.resultList