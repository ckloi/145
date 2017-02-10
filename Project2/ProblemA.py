def refineString(x):
    result = x.replace(" ", ",").replace("NA", "*")
    return result[:-1]
#
# #return the number
# def numOfNA(x):
#     counter = 0
#     for k in x:
#         if k is "*":
#             counter += 1
#     return counter

#compare if key in dictonary is match with line with 'NA'/'*'
def isMatch(key, NAkey):
    for i in range(len(key)):
        if NAkey[i] == "*":
            continue
        if key[i] != NAkey[i]:
            return False
    return True


def calcfreqs(infile, nqs, maxrat):
    try:
        fdfile = open(infile)
        freqs = {}
        #read lines from file
        inputList = list(fdfile.readlines())
        #replace ',' from ' ' and '*' from 'NA'
        #so it would be '3,4,5' if with NA, '3,*,5'
        refinedInputList = map(refineString, inputList)

        #initialize the dictonary
        for i in refinedInputList:
            if "*" not in i:
                if i not in freqs:
                    freqs[i] = 1
                else:
                    freqs[i] += 1
        #update the value when there is 'NA'
        for j in refinedInputList:
            if "*" in j:
                for i in freqs.keys():
                    if isMatch(i, j):
                       # size = numOfNA(j)
                        freqs[i] += float(nqs - j.count('*')) / float(nqs)
        return freqs
    except:
        raise Exception("Unable to open file")


def highfreqs(freqs, k):
    subfreqs = {}
    vkeys = list(freqs.keys())
    vvalues = list(freqs.values())
    if k < 0:
        for i in range(k):
            # find the min value each time
            vvaluesIndex = vvalues.index(min(vvalues))
            # add this to the return list
            subfreqs[vkeys[vvaluesIndex]] = vvalues[vvaluesIndex]
            # delecte the max and find the next max
            vkeys.pop(vvaluesIndex)
            vkeys.pop(vvaluesIndex)
    else:
        for i in range(k):
            # find the max value each time
            vvaluesIndex = vvalues.index(max(vvalues))
            # add this to the return list
            subfreqs[vkeys[vvaluesIndex]] = vvalues[vvaluesIndex]
            # delecte the max and find the next max
            vkeys.pop(vvaluesIndex)
            vkeys.pop(vvaluesIndex)
    return subfreqs
