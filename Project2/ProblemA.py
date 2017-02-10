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

        refinedInputList = map(refineString, inputList)

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




    # try:
    #     fdfile = open(infile)
    #     freqs = {}
    #     #first add the keys '1,2,3'
    #     for i in fdfile.readlines():
    #         #remove the whitespace characters
    #         i.strip()
    #         #remove the empty spcace
    #         nkeys = i.replace(' ', ',')
    #         if "NA" not in nkeys:
    #             if nkeys not in freqs.keys():
    #                 freqs[nkeys] = 0
    #     #now update the value, repeat code because have to have the keys first
    #     #otherwise if the line with NA before a unique store will be missed.
    #     target = freqs.keys()
    #     for j in fdfile.readlines():
    #         j.strip()
    #         k = j.replace(' ',',')
    #         #now j should be '1,2,3..'
    #
    #         if 'NA' not in k:
    #             freqs[k] += 1
    #         else:
    #             indexOfNA = nalist(k)
    #             for i in len(k):
    #                 for j in len(indexOfNA):
    #                     if i is indexOfNA[j]:
    #                         continue
    #                     else:
    #                         target = filter(lambda key: key[i] is k[i], target)
    #             #
    #             freqs[target] += (1 - len(indexOfNA)/nqs)
    #
    # except:
    #     raise Exception("Unable to open file")
