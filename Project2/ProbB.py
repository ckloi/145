import threading
import os

class threasdClass(threading.Thread):
    resultList = []
    id = 0
    lastThread = 0
    extraLine = False
    def __init__(self,sbyte,fd,chucksize):
        threading.Thread.__init__(self)
        #this is for each thread's return list
        self.localList = []
        self.startbyte = sbyte
        self.chucksize = chucksize
        self.myid = threasdClass.id
        threasdClass.id += 1
        self.fd = fd

    def run(self):
        l = self.fd.read(self.chucksize)
        # check end of line for the last char of the chuck
        flag = False
        if l.endswith('\n'):
            l = l[:-1]
        # if data is splitted into two chunk
        else:
            flag = True
        #put every number of chars of each line into the local lsit
        self.localList = map(lambda x: len(x),l.split('\n'))
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
    if ntrh > fSize:
        raise Exception('number of threads is greater than file size')
    chucksize = fSize / ntrh
    lastchuck = fSize

    for i in range(ntrh):
        #print i
        startbyte = i * chucksize
        #lastchuck -= startbyte
        if i is (ntrh - 1):
            chucksize = fSize - startbyte
        print chucksize
        t = threasdClass(startbyte,fd,chucksize)
        t.start()
    return threasdClass.resultList