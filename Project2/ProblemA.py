import os

#i am not sure what the maxrat should do, so haven't test
#and it is way too long :<
def calcfreqs(infile, nqs, maxrat):
    try:
        fdfile = open(infile)
        freqs = {}
        #first add the keys '1,2,3'
        for i in fdfile.readlines():
            #remove the whitespace characters
            i.strip()
            #remove the empty spcace
            nkeys = i.replace(' ', ',')
            if "NA" not in nkeys:
                if nkeys not in freqs.keys():
                    freqs[nkeys] = 0
        #now update the value, repeat code because have to have the keys first
        #otherwise if the line with NA before a unique store will be missed.
        target = freqs.keys()
        for j in fdfile.readlines():
            j.strip()
            k = j.replace(' ',',')
            #now j should be '1,2,3..'

            if 'NA' not in k:
                freqs[k] += 1
            else:
                indexOfNA = nalist(k)
                for i in len(k):
                    for j in len(indexOfNA):
                        if i is indexOfNA[j]:
                            continue
                        else:
                            target = filter(lambda key: key[i] is k[i], target)
                #
                freqs[target] += (1 - len(indexOfNA)/nqs)

    except:
        raise Exception("Unable to open file")

#this return the list of the index of NA in the line with NA
def nalist(nkeys):
    indexlist = []
    index = 0
    while index < len(nkeys):
        index = nkeys.find('NA', index)
        indexlist.append(index)
        if index == -1:
            break
        index += 2
    return indexlist

def highfreqs(freqs,k):
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
            #find the max value each time
            vvaluesIndex = vvalues.index(max(vvalues))
            #add this to the return list
            subfreqs[vkeys[vvaluesIndex]] = vvalues[vvaluesIndex]
            #delecte the max and find the next max
            vkeys.pop(vvaluesIndex)
            vkeys.pop(vvaluesIndex)
    return subfreqs
