import ProbB

f = open('infile.txt')

resultlist = []

for l in f:
    resultlist.append(len(l[:-1]))

print resultlist

resultlistb = ProbB.linelengths('infile.txt',6)
print resultlistb

print 'number of lines in the file is: ' + str(len(resultlistb))

for i in range(len(resultlist)):
    if resultlist[i] != resultlistb[i]:
        print 'two list are not equal in line: ' + str(i)
        continue