import ProbC

results = ProbC.storesim(10000,2,2.2,2,2)

print "Mean customer wait time: %f" % (results[0],)
print "Proportion of customers served immediately: %f" % (results[1],)
print "Proportion of deliveries served to customers immediately: %f" % (results[2],)
