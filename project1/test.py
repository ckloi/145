
import os

import fs

fs.init('abc')

fs.create('f1',4)

fs.create('f2',7)

fs.create('f3',8)

fs.mkdir('asd')

fs.chdir('asd')

fs.mkdir('bsd')

fs.chdir('bsd')

fs.create('fs',5)

fs.mkdir('ade')


fs.chdir('/asd/bsd/ade')


print fs.curDir.contentList

print fs.memory

print fs.curDir.dirName

print fs.nativeFD

print fs.rootDir.dirName

print fs.rootDir.contentList



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







