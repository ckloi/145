import os

import fs


def prn(x):
    try:
        return "Dir " + x.dirName
    except:
        return "File " + x.fileName


# file system tree #1
#now it is on the root directory.
fs.init('abc')

fs.mkdir('a')

fs.mkdir('a/b1')
print fs.listdir('a')

#now it is on the root directory.
#fs.chdir('a')


fs.chdir('/')

fs.create('fa', 17)
print fs.listdir('.')

#on a directory
fs.chdir('a')

fs.mkdir('b2')

fs.mkdir('/a/b3')

#now on drectory b3

fs.chdir('b3')

fs.mkdir('/a/b1/c1')
print fs.listdir('/a/b1')

fs.create('/a/b3/fc', 30)
fcd = fs.open('/a/b3/fc', 'w')
fs.write(fcd, '/nnow we needtousegitagain/n')
fs.close(fcd)
fcd1 = fs.open('/a/b3/fc', 'r')
print fs.readlines(fcd1)
print fs.read(fcd1, 30)


fs.chdir('..')

fs.create('fb', 29)
fbd = fs.open('fb', 'w')
fs.write(fbd, 'quizz is so annoying./n')

fs.close(fbd)

fs.chdir('/a/')

fs.chdir('b1/c1')

fs.create('fd', 50)
fdd = fs.open('fd', 'w')
fs.write(fdd, '/nRebasing and final pull requests.')
fs.close(fdd)
fdd1 = fs.open('fd', 'r')
print fs.read(fdd1, 5)
fs.close(fdd1)

fs.chdir('/a/')

fs.chdir('b3/')

fs.mkdir('c3')

fs.chdir('/')

# fs.create('/fa', 17)  # bug
#
# fs.create('fa', 12)  # bug can create duplicate file

# fs.mkdir('a')        # mkdir can detect duplicate directory

fs.mkdir('/a/b3/c3/d3')

fs.create('a/b3/c3/d3/fg', 30)
fgd = fs.open('a/b3/c3/d3/fg', 'w')
fs.write(fgd, 'this is a dummy file/n')
fs.close(fgd)
fgd1 = fs.open('a/b3/c3/d3/fg', 'r')
print fs.readlines(fgd1)
fs.close(fgd)


fs.chdir('a')

fs.mkdir('b1/c2')  # fs.mkdir('/a/b1/c2')

fa = fs.open('/fa','w')

fs.write(fa,'wow,ecs145issuck!')

fs.seek(fa,5)

fs.write(fa,'sss')

fa1 = fs.open('/fa','r')


#fs.seek(fa1,2)

print fs.read(fa1,5)




def printAll(root):
    print "Current Directory is " + root.dirName
    print list(map(prn, root.contentList))
    for i in root.contentList:
        if isinstance(i, fs.Directory):
            printAll(i)

def printAllFiles(root):
    for i in root.contentList:
        if isinstance(i, fs.TextFile):
            print "File Name : " + i.fileName
            print i.readlines()
            print "File size : " + str(i.bytesUsed())
        else:
            printAllFiles(i)



#printAll(fs.glbl.rootDir)
print '------------------------'
#printAllFiles(fs.glbl.rootDir)
