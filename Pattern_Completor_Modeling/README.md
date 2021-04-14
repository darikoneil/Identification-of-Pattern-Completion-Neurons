# Installation

### 1.) Select your linux distribution by copy & pasting relevant folder contents into Modsemble_Modeling directory
### 2.) Delete unused distribution to ensure there is absolutely no chance of cross-talk. Then run appropriate setup shell script

# Notes
### A.) Enter tmux kill-session -t multiMDL-0 in any of the terminals to shut down tmux after multicore processing
### B.) RED HAT DISTRIBUTIONS ONLY: You must set or change parameters using PGUI or by hand
### C.) Parameter Search can be an optimized process but BCFW is fast enough that it is presently not really worth it; informed parameter selection can be easily added in one or two lines via the outer loop of the BCFW object (see Loopy Model Collection).
### D.) If you choose multicore the structural learning AND the parameter estimation will be parallelized. HOWEVER, the structural learning is parallelized within MATLAB because it is thread-safe. The parameter estimation is parallelized because of issues with thread-safety when interfacing matlab with external languages. 
### E.) For multicore processing to work the system load can potentially be such that processes are killed/performance slow due to resource allocation not accounting for Matlab's implicit multithreading. This has been alleviated by forcing the cpu affinity for each worker. However, doing so can then induce quite extreme performance slowdowns. This will be fixed ASAP. I recommend checking for yourself whether implicit multithreading is an issue for your dataset, if you need to use multicore processing.
### F.) Some issues with GLMnet compilation & most recent versions of Matlab when many neighborhoods are required. This manifests through the skipping of iterations during parallel functions (e.g., 1, 2, 3, 5, 12, 13, 14, 15) and indexing errors during for-loops (sending two neighborhoods during a single iteration to the GLMnet function). In either case, simply run additional loops for missing iterations as the errors are essentially random and will not repeat the second time. This will be fixed whenever how to circumvent these errors or if/when I mgirate the code to a non-interpreter language as the errors are emerging from Matlab itself).

# Forthcoming
### GUI Refinement 
### Additional Options (ensemble import options, target selection options, spatial contour import/export)
### Reinsertion of witheld features including various structural learning methods & multi-frame ensembles
### .Mex for Windows OS

# Potentially Forthcoming
### Conversion to C++ 
### Conversion to Standalone
