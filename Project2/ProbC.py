from SimPy.Simulation import *
from random import Random, gammavariate


# Global class
class G:
    S = None
    Rnd = Random(12345)

class Customer(Process):
    def __init__(self, ac, bc):
        Process.__init__(self)
        self.Type = 'C'
        self.Alpha = ac
        self.Beta = bc
    def Run(self):
        while 1:
            # Wait until next customer order arrives
            yield hold, self, G.Rnd.gammavariate(self.Alpha, self.Beta)
            # Request Store Resource
            yield request, self, G.S

            # If there is stock available, increase number of customers served,
            #   update amount of customers served immediately, and decrease the
            #   stock
            if G.S.stock:
                G.S.numCust += 1
                G.S.servedImmediately += 1
                G.S.stock -= 1
            else:
                # Add customer to waiting list (value in list is time when
                #   order arrived)
                G.S.waiting.append(now())

            yield release, self, G.S

class Inventory(Process):
    def __init__(self, ai, bi):
        Process.__init__(self)
        self.Type = 'I'
        self.Alpha = ai
        self.Beta = bi
    def Run(self):
        while 1:
            # Wait for next delivery to occur
            yield hold, self, G.Rnd.gammavariate(self.Alpha, self.Beta)
            # Request Store Resource
            yield request, self, G.S

            # Increase the number of deliveries
            G.S.invDeliveries += 1
            # If nobody is waiting, increase the stock
            if len(G.S.waiting) is 0:
                G.S.stock += 1
            # If customers are waiting, serve (delete) the first customer in the
            #   list, update total time to include amount of time the customer
            #   waited for their order to be filled, increase number of customers
            #   served, and increase number of deliveries immediately served to
            #   a customer.
            else:
                t = G.S.waiting.pop(0)
                G.S.waitTime += now() - t
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
    waitTime = 0
    # Number of orders filled immediately
    servedImmediately = 0
    # Number of inventory deliveries served to customers immediately
    deliveryToCust = 0
    # List to represent customers waiting
    waiting = []
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
        meanWaitTime = float(G.S.waitTime)/float(G.S.numCust)
        orderFilledImmediately = float(G.S.servedImmediately)/float(G.S.numCust)
        deliveryToOrder = float(G.S.deliveryToCust)/float(G.S.invDeliveries)
        return [meanWaitTime, orderFilledImmediately, deliveryToOrder]

    results = storesim(10000,2,2.2,2,2)
    print "Mean customer wait time: %f" % (results[0],)
    print "Proportion of customer orders filled instantly: %f" % (results[1],)
    print "Proportion of inventory deliveries immediately dispersed: %f" % (results[2],)

if __name__ == '__main__':
    main()
