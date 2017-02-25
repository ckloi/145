from SimPy.Simulation import *
import random


# class Stats:


class Customer(Process):
    def __init(self, a, b):
        Process.__init__(self)
        self.Type = 'C'
        self.aplha = a
        self.beta = b
    def Run(self):
        while 1:
            nextCust = random.gammavariate(self.alpha, self.beta)
            yield hold, self, nextCust
            S = Store(self.type)
            activate(S,S.Run())

class Inventory(Process):
    def __init__(self, a, b):
        Process.__init__(self)
        self.Type = 'I'
        self.alpha = a
        self.beta = b
    def Run(self):
        while 1:
            nextInv = random.gammavariate(self.alpha, self.beta)
            yield hold, self, nextInv
            S = Store(self.type, nextInv)
            activate(S,S.Run())

class Store(Process):
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
    def __init__(self, typ, time):
        Process.__init__(self)
        self.Type = typ
        self.time = time
    def Run(self):
        # Serve Customer
        if self.Type = 'C':
            # If there is stock, serve customer immediately
            if stock:
                servedImmediately += 1
                stock -= 1
            # If there is no stock, add customer to waiting list
            else:
                # 1 is just a placeholder to show there is a customer waiting
                waiting.append(1)
            # Increment number of customers
            numCust += 1

        # Update inventory
        elif self.Type = 'I':
            # If ther is no one in the waiting list, increment stock
            if not waiting:
                stock += 1
            # If there are people in the waiting list, make the waiting list one
            # shorter and add waiting time
            else:
                waiting = [1:]
                custWait += self.time
                deliveryToCust += 1
            invDeliveries += 1
