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
from scipy import linalg
import pickle
import gzip
from pkg_resources import resource_filename
import sys

class HopPat:

    def __init__(self, square_size):
        self.pattern_length = square_size
        self.pattern_width = square_size

    def create_random_pattern(self, on_probability=0.5):
        p = np.random.binomial(1, on_probability, self.pattern_length * self.pattern_width)
        p = p * 2 - 1  # map {0, 1} to {-1 +1}
        return p.reshape((self.pattern_length, self.pattern_width))

    def create_random_pattern_list(self, nr_patterns, on_probability=0.5):
        p = list()
        for i in range(nr_patterns):
            p.append(self.create_random_pattern(on_probability))
        return p

    def reshape_patterns(self, pattern_list):
        """
        reshapes all patterns in pattern_list to have shape = (self.pattern_length, self.pattern_width)

        Args:
            self:
            pattern_list:

        Returns:

        """
        new_shape = (self.pattern_length, self.pattern_width)
        return reshape_patterns(pattern_list, new_shape)
        
def reshape_patterns(pattern_list, shape):
    """
    reshapes each pattern in pattern_list to the given shape

    Args:
        pattern_list:
        shape:

    Returns:

    """
    reshaped_patterns = [p.reshape(shape) for p in pattern_list]
    return reshaped_patterns
