import ProbB
import time

nonthread_start_time = time.time()
f = open('infile.txt')

resultlist = []
for l in f:
    resultlist.append(len(l[:-1]))
nonthread_time = time.time() - nonthread_start_time

print resultlist

thread_start_time = time.time()
resultlistb = ProbB.linelengths('infile.txt', 0)
thread_time = time.time() - thread_start_time

if thread_time > nonthread_time:
    print "using thread is: " + str(thread_time - nonthread_time) + " faster!"
elif thread_time < nonthread_time:
    print 'using thread is: ' + str(nonthread_time - thread_time) + ' slower!'
else:
    print 'thread and nonthread use the same amount of time'

print resultlistb

print 'number of lines in the file is: ' + str(len(resultlistb))

for i in range(len(resultlist)):
    if resultlist[i] != resultlistb[i]:
        print 'two list are not equal in line: ' + str(i)
        continue
f.close()
