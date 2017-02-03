import os

import fs


def prn(x):
    try:
        return "Dir " + x.dirName
    except:
        return "File " + x.fileName


# file system tree #1

fs.init('1')

fs.mkdir('a')

fs.mkdir('a/b1')

fs.chdir('a')

fs.chdir('/')

fs.create('fa', 17)

fs.chdir('a')

fs.mkdir('b2')

fs.mkdir('/a/b3')

fs.chdir('b3')

fs.mkdir('/a/b1/c1')

fs.create('/a/b3/fc', 24)

fs.chdir('..')

fs.create('fb', 25)

fs.chdir('/a/')

fs.chdir('b1/c1')

fs.create('fd', 50)

fs.chdir('/a/')

fs.chdir('b3/')

fs.mkdir('c3')

fs.chdir('/')

# fs.create('/fa', 17)  # bug
#
# fs.create('fa', 12)  # bug can create duplicate file

# fs.mkdir('a')        # mkdir can detect duplicate directory

fs.mkdir('/a/b3/c3/d3')

fs.create('a/b3/c3/d3/fg', 1)

fs.chdir('a')

fs.mkdir('b1/c2')  # fs.mkdir('/a/b1/c2')


def printAll(root):
    print "Current Directory is " + root.dirName
    print list(map(prn, root.contentList))
    for i in root.contentList:
        if isinstance(i, fs.Directory):
            printAll(i)


printAll(fs.glbl.rootDir)
