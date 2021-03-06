# synchrony in brain regions
This repository contains MATLAB scripts and preprocessed fMRI data employed to create figures and reach conclusions in the following paper:
https://www.biorxiv.org/content/10.1101/2020.04.17.047233v5.full

---
Directory names within `fmri_data/` and `scripts/` correspond to the respective dataset. See `readme.txt` within `fmri_data/` for more information on the respective dataset. 

To run the MATLAB scripts, 
1. Add all subdirectories of `synchrony/scripts/` to your environment path. 
2. Make sure that the `DIR` variable in `synchrony/scripts/utilts/readin.m` is correctly set. `DIR` corresponds to the path to `synchrony/` from your MATLAB's present working directory. 

Scripts are partitioned based on the dataset they analyze. Further details on which figures in the paper the respective script reproduces can be found in comments at the top of the script.

---
Acknowledgements: initial version of scripts written by Corey Weistuch; Botond Antal preprocessed the fMRI data
