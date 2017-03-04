import ProbB
import sys
import os
import time

fileName = sys.argv[1]
numThreads = int(sys.argv[2])
filePath = 'tmp/' + fileName
nonthread_start_time = time.time()

f = open(filePath, 'r')
resultlist = []
fSize = os.path.getsize(filePath)
f.seek(0)
contents = f.read(fSize)
f.close()
if contents.endswith('\n'):
    contents = contents[:-1]
resultlist = map(len, contents.split('\n'))
nonthread_time = time.time() - nonthread_start_time

#print resultlist

thread_start_time = time.time()
resultlistb = ProbB.linelengths(filePath, numThreads)
thread_time = time.time() - thread_start_time

width = 2 - len(str(numThreads))
print "Number of lines read: %d" % (len(resultlistb),)
print "Total time with no threads: % *f seconds" % (10 - width, nonthread_time,)
print "Total time with %d threads: % *f seconds" % (numThreads, 10, thread_time)

# if thread_time > nonthread_time:
#     print "using thread is: " + str(thread_time - nonthread_time) + " faster!"
# elif thread_time < nonthread_time:
#     print 'using thread is: ' + str(nonthread_time - thread_time) + ' slower!'
# else:
#     print 'thread and nonthread use the same amount of time'
#
# print resultlistb
#
# print 'number of lines in the file is: ' + str(len(resultlistb))
#
# for i in range(len(resultlist)):
#     if resultlist[i] != resultlistb[i]:
#         print 'two list are not equal in line: ' + str(i)
#         continue
