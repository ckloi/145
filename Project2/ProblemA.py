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
    inputList = fdfile.readlines()
    # replace ',' from ' ' and '*' from 'NA'
    # so '3 4 5' would become '3,4,5' and '1 2 NA' would become '1,2,*'
    refinedInputList = map(refineString, inputList)
    # create a nalist contain all key that has NA in it
    NAList = []
    # initialize the dictonary
    for ratings in refinedInputList:
        ratList = ratings.split(',')
        # Check if number of answers  > number of questions
        if len(ratList) > nqs:
            raise Exception("Error: one or more lines not in correct format.")
        # Check if any rating is above maxrat
        for rat in ratList:
            # Cast maxrat to string since each element in ratList is a string
            if i > str(maxrat) and i is not '*':
                raise Exception("Error: one or more lines not in correct format.")
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
    vkeys = freqs.keys()
    vvalues = freqs.values()
    for i in range(abs(k)):
        if k < 0:
            value = min(vvalues)
        else:
            # find the max value each time
            value = max(vvalues)

        # Filter out the keys in freqs that provide the max/min value
        #   and add each key and value to the subdictionary
        for item in filter(lambda x: freqs[x] == value, freqs.keys()):
            vIndex = vkeys.index(item)
            # add this to the return list
            subfreqs[item] = vvalues[vIndex]
            # delete the max and find the next max
            vkeys.pop(vIndex)
            vvalues.pop(vIndex)
    return subfreqs
