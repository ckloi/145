import ProbB
import os

print ProbB.linelengths('testB', 300)

f = open('testB', 'r')
resultlist = []
fSize = os.path.getsize('testB')
f.seek(0)
contents = f.read(fSize)
if contents.endswith('\n'):
    contents = contents[:-1]
resultlist = map(len, contents.split('\n'))

print resultlist
