
#Hopfield Networks created as described by:
# Wulfram Gerstner, Werner M. Kistler, Richard Naud, and Liam Paninski.
# Neuronal Dynamics: From Single Neurons to Networks and Models of Cognition.
# Cambridge University Press, 2014.

#Run for simulation of CRFS in: 
#Identification of Pattern Completion Neurons in Neuronal Ensembles using Probabilistic Graphical Models
#Luis Carrillo-Reid, Neurobiology Institute UNAM
#Shuting Han, Columbia University
#Darik O'Neil, Columbia University
#Ekaterina Taralova, Columbia University
#Tony Jebara, Columbia University
#Rafael Yuste, Columbia University

import numpy as np
import HopCRF

class HopNet:

    """
    state(numpy.ndarray)
    weights(numpy.ndarray)
    num_neur(int)
    """

    def __init__(self,num_neur):
        #intialize number of neurons, state, & weights
        self.num_neur = num_neur
        self.state = 2*np.random.randint(0, 2, self.num_neur)-1
        self.weights = 0
        self.reset_weights()
        self._update_method = _get_sign_update_function()

    def reset_weights(self):
        self.weights = 1.0/self.num_neur *\
            (2*np.random.rand(self.num_neur, self.num_neur)-1)

    def sync_update(state_s0, weights):
        h = np.sum(weights * state_s0, axis=1)
        s1 = np.sign(h)
        # by definition, neurons have state +/-1. If the
        # sign function returns 0, we set it to +1
        idx0 = s1 == 0
        s1[idx0] = 1
        return s1

    def iterate(self):
        self.state = self._update_method(self.state, self.weights)

    def run(self, nr_steps=5):
        states = list()
        states.append(self.state.copy())
        for i in range(nr_steps):
            self.iterate()
            states.append(self.state.copy())
        return states

    def store_pattern(self, pattern_list):
           all_same_size_as_net = all(len(p.flatten()) == self.num_neur for p in pattern_list)
           if not all_same_size_as_net:
                errMsg = "Not all patterns in pattern_list have exactly the same number of states " \
                     "as this network has neurons n = {0}.".format(self.num_neur)
                raise ValueError(errMsg)
           self.weights = np.zeros((self.num_neur, self.num_neur))
           # textbook formula to compute the weights:
           for p in pattern_list:
                p_flat = p.flatten()
                for i in range(self.num_neur):
                    for k in range(self.num_neur):
                        self.weights[i, k] += p_flat[i] * p_flat[k]
           self.weights /= self.num_neur
           # no self connections:
           np.fill_diagonal(self.weights, 0)
           
    def set_state_from_pattern(self, pattern):
        self.state = pattern.copy().flatten()
        
        
    
    
    
    
def _get_sign_update_function():
    """
    for internal use

    Returns:
        A function implementing a synchronous state update using sign(h)
    """
    def upd(state_s0, weights):
        h = np.sum(weights * state_s0, axis=1)
        s1 = np.sign(h)
        # by definition, neurons have state +/-1. If the
        # sign function returns 0, we set it to +1
        idx0 = s1 == 0
        s1[idx0] = 1
        return s1
    return upd
