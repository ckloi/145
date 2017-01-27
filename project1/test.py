
import os

import fs


#f = open('abc','w')


#f.write('hello')

#f.flush()


fs.init('abc')

fs.create('f1',3)

fs.create('f2',7)

fd = fs.open('f1','w')

fd2 = fs.open('f2','w')


fs.seek(fd,0)

#print(fs.pos(fd))

fs.write(fd,"1")

print(fs.pos(fd))

fs.write(fd,"22")

print(fs.pos(fd))

fs.write(fd2,"qq")

#fs.write(fd,"2")
#
#print(fs.pos(fd))






#print (os.path.getsize('abc'))