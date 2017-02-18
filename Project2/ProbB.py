import threading
import os
import time

class threasdClass(threading.Thread):
    resultList = []
    id = 0
    lastThread = 0
    extraLine = False
    extraLineLock = threading.Lock()
    #def __init__(self,sByte, eByte,fd):
    def __init__(self,sbyte,fd,chucksize):
        threading.Thread.__init__(self)
        self.localList = []
        self.startbyte = sbyte
        self.chucksize = chucksize
        #self.endbyte = eByte
        self.myid = threasdClass.id
        threasdClass.id += 1
        self.fd = fd

    def run(self):
        #self.fd.seek(self.startbyte)
        #l = self.fd.read(self.endbyte - self.startbyte + 1)
        l = self.fd.read(self.chucksize)
        # check end of line
        flag = False
        if l.endswith('\n'):
            l = l[:-1]
        # if data is splitted into two chunk
        else:
            flag = True

        self.localList = map(lambda x: len(x),l.split('\n'))
        while 1:
            if threasdClass.lastThread == self.myid:
                if threasdClass.extraLine:
                    threasdClass.resultList[-1] += self.localList.pop(0)
                threasdClass.resultList.extend(self.localList)
                threasdClass.extraLineLock.acquire()
                threasdClass.lastThread += 1
                if flag:
                    threasdClass.extraLine = True
                else:
                    threasdClass.extraLine = False
                threasdClass.extraLineLock.release()
                break
            else:
                time.sleep(0)




def linelengths(filenm, ntrh):
    fd = open(filenm)
    fSize = os.path.getsize(filenm)
    if ntrh > fSize:
        raise Exception('number of threads is greater than file size')
    chucksize = fSize / ntrh
    lastchuck = fSize
    myThreads = []

    for i in range(ntrh):
        #print i
        startbyte = i * chucksize
        #lastchuck -= startbyte
        if i is (ntrh - 1):
            chucksize = fSize - startbyte
        t = threasdClass(startbyte,fd,chucksize)
        myThreads.append(t)
        t.start()

    for t in myThreads:
        t.join()
        
    return threasdClass.resultList
