import threading
import os

class threasdClass(threading.Thread):
    resultList = []
    id = 0
    lastThread = 0
    extraLine = False
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
    #nextByte = 0
    if ntrh > fSize:
        raise Exception('number of threads is greater than file size')
    chucksize = fSize / ntrh

    for i in range(ntrh):
        #startByte = nextByte
        # if i is not ntrh - 1:
        #     endByte = startByte + (fSize/ntrh)
        #     nextByte = endByte + 1
        # else:
        #     endByte = fSize - 1
        startbyte = (i-1) * chucksize
        #t = threasdClass(startByte,endByte,fd,)
        t = threasdClass(startbyte,fd,chucksize)
        t.run()
    return threasdClass.resultList