
import os

import fs

def prn(x):
	try:
		return "Dir " + x.dirName
	except:
		return "File " + x.fileName

fs.init('abc')

fs.create('f1',4)

fs.create('f2',7)

fs.create('f3',8)

fs.mkdir('a')

fs.chdir('a')

fs.mkdir('b')

fs.chdir('b')

fs.create('fs',5)


fs.mkdir('c')

fs.mkdir('d')


print "Current Directory is " + fs.curDir.dirName

print list(map(prn,fs.curDir.contentList))








# fs.suspend()
#
# fs.resume()
#
#
# print fs.curDir.contentList
#
# print fs.memory
#
# print fs.curDir.dirName
#
# print fs.nativeFD
#
# print fs.rootDir.dirName
#
# print fs.rootDir.contentList

#
# fd = open('vsa','r+w')
#
# fd.write('first')
#
# fd.close()
#
# fd = open('vsa','r+w')
#
# fd.seek(6)
#
# fd.write('second')
#
# fd.seek(0)
#
# print fd.read(20)







