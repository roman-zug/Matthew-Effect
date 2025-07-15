# Matthew-Effect

[![DOI](https://zenodo.org/badge/952036632.svg)](https://doi.org/10.5281/zenodo.15910468)

This repository contains MATLAB files used to develop the model and to create the figures in the paper 

"Luck can explain the positive link between fecundity and longevity: The Matthew effect in social insects and beyond". 

The code implements the model, performs simulations, and produces figures.

This project is licensed under the [MIT License](LICENSE).

The repository contains three directories:

- `figures` - contains fig and jpf files for all figures, including supplementary figures
- `functions`- contains all functions that are used in the scripts
- `ścripts` - contains all script files (figure scripts and auxiliary scripts)

To create Figure 1, run the script `Figure_1.m`, and so on. Some scripts require other scripts to be run first. 
For example, to create Figure 5, you will first need to run `maketask.m`, `runtask.m`, `collate_fitness.m`. `optimization.m`, and `categorize.m` 
(in this order) before you can run `Figure_5.m`. 
