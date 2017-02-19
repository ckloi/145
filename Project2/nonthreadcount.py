import ProbB
import sys
import time

fileName = sys.argv[1]
numThreads = int(sys.argv[2])
filePath = '/tmp/' + fileName
nonthread_start_time = time.time()
f = open(filePath, 'r')

resultlist = []
for l in f:
    resultlist.append(len(l[:-1]))
nonthread_time = time.time() - nonthread_start_time

#print resultlist

thread_start_time = time.time()
resultlistb = ProbB.linelengths(filePath, numThreads)
thread_time = time.time() - thread_start_time

print "Number of lines read: " + str(len(resultlistb))
print "Total time with no threads: " + str(nonthread_time)
print "Total time with " + str(numThreads) + " threads: " + str(thread_time)

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
f.close()
