
import os

import fs

fs.init('abc')

fs.create('f1',4)

fs.create('f2',7)

fs.create('f3',8)



fd1 = fs.open('f1','w')

fs.write(fd1,'a')

# fs.close(fd1)
#
# fd1 = fs.open('f1','w')


fs.write(fd1,'\n\nc')

fd1 = fs.open('f1','r')

fs.delfile('f3')

print fs.readlines(fd1)


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







