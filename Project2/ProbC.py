from SimPy.Simulation import *
import random


class Stats:


class Customer(Process):
    def __init(self,a,b):
        Process.__init__(self)
        self.Type = 'C'
        self.aplha = a
        self.beta = b
    def Run(self):
        while 1:
            yield hold,random.gammavariate(self.alpha, self.beta)
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
            yield hold,self,random.gammavariate(self.alpha, self.beta)
            S = Store(self.type)
            activate(S,S.Run())


class Store(Process):
    stock = 0
    numCust = 0
    custWait = 0
    def __init__(self,typ,time):
        Process.__init__(self)
        self.Type = typ
    def Run(self):
        if self.Type = 'C':
            # Serve Customer
        elif self.Type = 'I':
            # Update inventory
