# Replace all spaces with commas and all NA's with *
def refineString(x):
    result = x.replace(" ", ",").replace("NA", "*")
    return result[:-1]


# compare if key in dictonary is match with line with 'NA'/'*'
def nMatched(key, NAkey, numqs):
    matched = 0
    for i in range(len(key)):
        # Don't increment if NA or comma (comma's should be at the same indices for both lists)
        if NAkey[i] == "*" or key[i] == ',':
            continue
        # If any part does not match, return 0
        if key[i] != NAkey[i]:
            return 0
        # Increment by a fraction of numqs for each i matched
        matched += pow(numqs, -1)
    return matched


def calcfreqs(infile, nqs, maxrat):
    try:
        fdfile = open(infile)
    except:
        raise Exception("Unable to open file")

    freqs = {}
    # read lines from file
    inputList = list(fdfile.readlines())
    # replace ',' from ' ' and '*' from 'NA'
    # so '3 4 5' would become '3,4,5' and '1 2 NA' would become '1,2,*'
    refinedInputList = map(refineString, inputList)
    # create a nalist contain all key that has NA in it
    NAList = []
    # initialize the dictonary
    for ratings in refinedInputList:
        if "*" not in ratings:
            if ratings not in freqs.keys():
                # Should be 1 at first
                freqs[ratings] = 1
            else:
                freqs[ratings] += 1
        else:
            NAList.append(ratings)
    # update the value when there is 'NA'
    for NARatings in NAList:
        for key in freqs.keys():
            freqs[key] += nMatched(key, NARatings, nqs)
    return freqs


def highfreqs(freqs, k):
    subfreqs = {}
    vkeys = list(freqs.keys())
    vvalues = list(freqs.values())
    for i in range(abs(k)):
        if k < 0:
            # find the min value each time
            vvaluesIndex = vvalues.index(min(vvalues))
        else:
            # find the max value each time
            vvaluesIndex = vvalues.index(max(vvalues))

        # add this to the return list
        subfreqs[vkeys[vvaluesIndex]] = vvalues[vvaluesIndex]
        # delete the max and find the next max
        vkeys.pop(vvaluesIndex)
        vvalues.pop(vvaluesIndex)
    return subfreqs
