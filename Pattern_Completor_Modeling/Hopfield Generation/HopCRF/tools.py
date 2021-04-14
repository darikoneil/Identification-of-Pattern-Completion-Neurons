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

class tools:

    def calculate_buffer(meanActivity, subgraphSize, numSubgraphs):
        target_active = (meanActivity/100)*subgraphSize*numSubgraphs
        sim_active = subgraphSize/2
        buffer_activity = (target_active - sim_active)/(subgraphSize*numSubgraphs)
        return buffer_activity

    def get_noisy_copy(template, noise_level):
        if noise_level == 0:
            return template.copy()
        if noise_level < 0 or noise_level > 1:
            raise ValueError("noise level is not in [0,1] but {}0".format(noise_level))
        linear_template = template.copy().flatten()
        n = np.prod(template.shape)
        nr_mutations = int(round(n * noise_level))
        idx_reassignment = np.random.choice(n, nr_mutations, replace=False)
        rand_values = np.random.binomial(1, 0.5, nr_mutations)
        rand_values = rand_values * 2 - 1  # map {0,1} to {-1, +1}
        linear_template[idx_reassignment] = rand_values
        return linear_template.reshape(template.shape)
        
    def reshape_patterns(pattern_list, shape):
        reshaped_patterns = [p.reshape(shape) for p in pattern_list]
        return reshaped_patterns
