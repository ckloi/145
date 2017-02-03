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
fs.write(fcd, '\nnow we needtousegitagain\n')
fs.close(fcd)
fcd1 = fs.open('/a/b3/fc', 'r')
print fs.readlines(fcd1)
print fs.read(fcd1, 30)
fs.close(fcd1)
fs.suspend()

fs.chdir('..')
fs.resume('abc')
fs.create('fb', 29)
fbd = fs.open('fb', 'w')
fs.write(fbd, 'quizz is so annoying.\n')

fs.close(fbd)

fs.chdir('/a/')
#in directory c1
fs.chdir('b1/c1')

fs.create('fd', 50)
fdd = fs.open('fd', 'w')
fs.write(fdd, '\nRebasing and final pull requests.')
fs.close(fdd)
fdd1 = fs.open('fd', 'r')
print fs.read(fdd1, 5)
fs.close(fdd1)

#now delete this file, to spare space for last file
fs.delfile('fd')

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
fs.write(fgd, 'this is a dummy file\n')
fs.close(fgd)
fgd1 = fs.open('a/b3/c3/d3/fg', 'r')
print fs.readlines(fgd1)
fs.close(fgd)


fs.chdir('a')

fs.mkdir('b1/c2')  # fs.mkdir('/a/b1/c2')
fs.mkdir('b1/c2/d2')
#in directory d2
fs.chdir('b1/c2/d2')
fs.create('fe', 50)
fed = fs.open('fe', 'w')
fs.write(fed, 'Using again the cherry-pick.\n')
fs.close(fed)
#write to file fg, to see if we can write continuously
# in directory d3
fs.chdir('/a/b3/c3/d3')
fgd2 = fs.open('fg','w')
fs.write(fgd2, 'adding more text to file fg')
fs.close(fgd2)
fgd3 = fs.open('fg','r')
print fs.readlines(fgd3)

fs.create('d2', 30)
fd2 = fs.open('d2', 'w')
fs.write(fd2, 'wow, CS major is jus so fun!')
fs.close(fd2)


fa = fs.open('/fa','w')

fs.write(fa,'wow,ecs145issuck!')

fs.seek(fa,5)

fs.write(fa,'sss')

fa1 = fs.open('/fa','r')


#fs.seek(fa1,2)

print fs.read(fa1,5)
#havn't close file fa
fs.close(fa1)
fs.chdir('/a')
print fs.listdir('.')

#this is just to test if it could delte directory with file consisted inside
#not enough space in native file to create this  file, if not some file are delete.
fs.create('b2/fb2',70)
fb2d = fs.open('b2/fb2', 'w')
fs.write(fb2d, 'this is to test if we \n could delete anythin inthe directory')
fs.close(fb2d)
fb21 =fs.open('b2/fb2', 'r')
print fs.readlines(fb21)
fs.close(fb21)
fs.deldir('b2')

print fs.isdir('/a/b1/c2')
print fs.isdir('/a/b3/fc')

#print fs.open('b2/fb2', 'r')
print fs.listdir('.')


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
