This repository continas the code for the simulation study described in Section 4 of "Multivaraite Representations of Univaraite Marked Hawkes Processes." 

Due to the computational demand of running the simulation study ```text big_study_parallel.R```, it is recommended to use a high computing resource. The SLURM file ```text big_study_parallel.sh``` resulted in a runtime of approximately 36 hours on the [NeSi high-computing server](https://www.nesi.org.nz/).

After running the simulation study, use the ```text DataCleaningForVisualization.R``` file before creating confidence interval and wireframe visualizations using the ```text PlotConfidenceIntervals.R``` and ```text CreateWireframe/R``` scripts, respectively.
