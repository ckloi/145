
import os

import fs


#f = open('abc','w')


#f.write('hello')

#f.flush()


fs.init('abc')

fs.create('f1',2)

fs.create('f2',7)

fd = fs.open('f1','r')

fs.seek(fd,0)





#print (os.path.getsize('abc'))