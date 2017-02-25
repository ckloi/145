from SimPy.Simulation import *
import random


# class Stats:


class Customer(Process):
    def __init(self,a,b):
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
    def __init__(self,a,b):
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
    stock = 0
    numCust = 0
    custWait = 0
    waiting = []
    def __init__(self,typ,time):
        Process.__init__(self)
        self.Type = typ
        self.time = time
    def Run(self):
        if self.Type = 'C':
            # Serve Customer
            if stock:
                stock -= 1
            else:
                # 1 is just a placeholder to show there is a customer waiting
                waiting.append(1)
        elif self.Type = 'I':
            # Update inventory
            if not waiting:
                stock += 1
            else:
                waiting = [1:]
                custWait += self.time
