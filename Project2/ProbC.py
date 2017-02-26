from SimPy.Simulation import *
import random


# Global class
class G:
    S = None

class Customer(Process):
    def __init__(self, ac, bc):
        Process.__init__(self)
        self.Type = 'C'
        self.alpha = ac
        self.beta = bc
    def Run(self):
        while 1:
            nextCust = random.gammavariate(self.alpha, self.beta)
            # Wait until next customer order arrives
            yield hold, self, nextCust
            # Request Store Resource
            yield request, self, G.S

            # If customers are waiting, make sure you update their wait time by
            #   the amount of time it took for current customer order to arrive
            if len(G.S.waiting) > 0:
                G.S.custWait += nextCust
            # If there is stock available, increase number of customers served,
            #   update amount of customers served immediately, and decrease the
            #   stock
            if G.S.stock:
                G.S.numCust += 1
                G.S.servedImmediately += 1
                G.S.stock -= 1
            else:
                # Add customer to waiting list (1 is just a placeholder)
                G.S.waiting.append(1)

            yield release, self, G.S

class Inventory(Process):
    def __init__(self, ai, bi):
        Process.__init__(self)
        self.Type = 'I'
        self.alpha = ai
        self.beta = bi
    def Run(self):
        while 1:
            nextInv = random.gammavariate(self.alpha, self.beta)
            # Wait for next delivery to occur
            yield hold, self, nextInv
            # Request Store Resource
            yield request, self, G.S

            # Increase the number of deliveries
            G.S.invDeliveries += 1
            # If nobody is waiting, increase the stock
            if len(G.S.waiting) is 0:
                G.S.stock += 1
            # If customers are waiting, serve (delete) the first customer in the
            #   list, increase number of customers served, and increase number
            #   of deliveries immediately served to a customer.
            else:
                del G.S.waiting[0]
                G.S.custWait += nextInv
                G.S.numCust += 1
                G.S.deliveryToCust += 1

            yield release, self, G.S

class Store(Resource):
    # Current stock
    stock = 0
    # Total number of customers
    numCust = 0
    # Total amount of inventory deliveries
    invDeliveries = 0
    # Total time customers have waited
    custWait = 0
    # Number of orders filled immediately
    servedImmediately = 0
    # Number of inventory deliveries served to customers immediately
    deliveryToCust = 0
    # List to represent customers waiting
    waiting = []
    # Thread ID
    nextID = 0
    def __init__(self):
        Resource.__init__(self)

def main():
    def storesim(maxsimtime, alphac, betac, alphai, betai):
        initialize()
        Cust = Customer(alphac,betac)
        activate(Cust,Cust.Run())
        Inv = Inventory(alphai,betai)
        activate(Inv,Inv.Run())
        G.S = Store()
        simulate(until=maxsimtime)
        meanWaitTime = float(G.S.custWait)/float(G.S.numCust)
        orderFilledImmediately = float(G.S.servedImmediately)/float(G.S.numCust)
        deliveryToOrder = float(G.S.deliveryToCust)/float(G.S.invDeliveries)
        return [meanWaitTime, orderFilledImmediately, deliveryToOrder]

    results = storesim(10000,2,2.2,2,2)
    print "Mean customer wait time: %f" % (results[0],)
    print "Proportion of customer orders filled instantly: %f" % (results[1],)
    print "Proportion of inventory deliveries immediately dispersed: %f" % (results[2],)

if __name__ == '__main__':
    main()
