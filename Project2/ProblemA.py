def refineString(x):
    result = x.replace(" ", ",").replace("NA", "*")
    return result[:-1]


def numOfNA(x):
    counter = 0
    for k in x:
        if k is "*":
            counter += 1
    return counter


def filtering(key, NAList):
    print key
    print NAList
    for i in range(len(key)):
        if NAList[i] == "*":
            continue
        if key[i] != NAList[i]:
            return False
    return True


def calcfreqs(infile, nqs, maxrat):
    try:
        fdfile = open(infile)
        freqs = {}
        inputList = list(fdfile.readlines())

        refinedInputList = (map(refineString, inputList))

        for i in refinedInputList:
            if "*" not in i:
                if i not in freqs:
                    freqs[i] = 1
                else:
                    freqs[i] += 1
        for j in refinedInputList:
            if "*" in j:
                for i in freqs.keys():
                    if filtering(i, j):
                        size = numOfNA(j)
                        freqs[i] += float(nqs - size) / float(nqs)
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
