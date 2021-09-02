# Demo of CRF code used in:

#### Identification of Pattern Completion Neurons in Neuronal Ensembles using Probabilistic Graphical Models
#### Luis Carrillo-Reid^, Neurobiology Institute UNAM
#### Shuting Han^, Columbia University
#### Darik O'Neil^, Columbia University
#### Ekaterina Taralova, Columbia University
#### Tony Jebara, Columbia University
#### Rafael Yuste, Columbia University
^denotes equal contribution
#### Journal of Neuroscience (2021; early access)
https://www.jneurosci.org/content/early/2021/08/19/JNEUROSCI.0051-21.2021





## Software Requirements
Linux only (Tested on Ubuntu 18.04.5 LTS)  
Recompilation of associated thirdparty mex-files requires GCC/G++ version 6.3.X  

## MATLAB Requirements
MATLAB 2019b with symbolic links (More recent versions of MATLAB are usually compatible)  
Signal Processing Toolbox  
Parallel-Computing Toolbox is not necessary, this demo is a single-process implementation  

## Third Party Dependencies
QPBO 1.32  
GLMNet  
MexCPP  

## Installation
Open a terminal in the folder "Pattern_Completor_Modeling"  
Enter bash UBUNTU_SETUP.sh in the terminal  
Enter "1" for "Yes" to install  

## Running the Demo
Open Matlab  
Run the Run_Demo script  
For ease of demoing, a small model option was included that is 1/10th the size of the network used in the publication. 

## Output
A figure highlighting the identified pattern completors and their respective coordinates is produced for each detected ensemble.
  
<img src="https://github.com/darikoneil/Identification-of-Pattern-Completion-Neurons-in-Neuronal-Ensembles-using-Probabilistic-Graphical-Mod/blob/main/Example.png">



