This repository contains the code for the simulation study described in Section 4 of [_Multivariate Representations of Univariate Marked Hawkes Processes_](https://arxiv.org/abs/2407.03619) by Louis Davis, Conor Kresin, Boris Baeumer, and Ting Wang, as submitted to Stochastic Processes and their Applications. 

Due to the computational demand of running the simulation study script ```big_study_parallel.R```, it is recommended to use a high computing resource. The example SLURM file ```big_study_parallel.sh``` resulted in a runtime of approximately 36 hours on the [NeSi high-computing server](https://www.nesi.org.nz/).

After running the simulation study, use the ```DataCleaningForVisualization.R``` script before creating confidence interval and wireframe visualizations using the ```PlotConfidenceIntervals.R``` and ```CreateWireframe/R``` scripts, respectively.
