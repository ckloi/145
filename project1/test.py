
import os

import fs

fs.init('abc')

fs.create('f1',4)

fs.create('f2',7)

#This one and the last one should be the same
print fs.glbl.memory

fs.mkdir('a')

fs.chdir('a')

fs.create('f3',8)

#fd3 = fs.open('f3', 'w')

#fs.write(fd3, "Hello\n")

#fd3 = fs.close(fd3)

#fd3 = fs.open('f3', 'r')

#fs.read(fd3, 2)

#fs.readlines(fd3)

#fd3 = fs.close(fd3)

fd1 = fs.open('/f1', 'w')

fs.write(fd1, "\n")

fd1 = fs.close(fd1)

fs.delfile('/f1')

print fs.glbl.memory

fs.create('f4', 3)

fs.mkdir('b')

fs.chdir('b')

fs.create('f5', 2)

fs.mkdir('c')

fs.chdir('c')

fs.create('f6', 3)

fs.chdir('/')

fs.deldir('a')

#This one and the first one should be the same
print fs.glbl.memory
