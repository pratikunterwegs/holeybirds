
# Source code and supplementary material for _Direct effects of flight feather molt on bird movement and habitat selection_

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- [![DOI:10.1101/2020.12.15.422876](https://img.shields.io/badge/bioRxiv-doi.org/10.1101/2020.12.15.422876-<COLOR>?style=flat-square)](https://www.biorxiv.org/content/10.1101/2020.12.15.422876v3) -->
<!-- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4287462.svg)](https://doi.org/10.5281/zenodo.4287462) -->

This is the source code for a manuscript that investigates the habitat use and movement strategies of four resident sub-tropical bird species during wing-moult, the process of replacing damaged flight feathers.

## Contact and Attribution

Please contact Pratik Gupte, Yosef Kiat, or Ran Nathan (PI) for questions about the project.

```md
Name: Pratik Rajan Gupte
Email: pratikgupte16@gmail.com OR p.r.gupte@rug.nl
ORCID: https://orcid.org/0000-0001-5294-7819

Name: Yosef Kiat
Email: yosef.kiat@gmail.com

Name: Ran Nathan
Email: r.nathan@huji.ac.il
```

<!-- Cite this repository archived on Zenodo as

```bibtex
@software{pratik_rajan_gupte_2022_6341440,
  author       = {Pratik Rajan Gupte and
                  Gregory F. Albery and
                  Jakob Gismann and
                  Amy R. Sweeny and
                  Franz J. Weissing},
  title        = {{Source Code and Supplementary Material for "Novel 
                   pathogen introduction rapidly alters the evolution
                   of movement, restructuring animal societies"}},
  month        = mar,
  year         = 2022,
  publisher    = {Zenodo},
  version      = {v1.0.1},
  doi          = {10.5281/zenodo.6341440},
  url          = {https://doi.org/10.5281/zenodo.6341440}
}
```
 -->

## Project Data

The data used for this the manuscript are available on Zenodo/Dryad/other at **data DOI**.

Please cite the project data as:
<!-- 

```bibtex
@dataset{pratik_rajan_gupte_2022_6331757,
  author       = {Pratik Rajan Gupte},
  title        = {{Reference data from the Pathomove simulation, for 
                   the manuscript "Novel pathogen introduction
                   rapidly alters the evolution of movement,
                   restructuring animal societies"}},
  month        = mar,
  year         = 2022,
  publisher    = {Zenodo},
  version      = {v1.0},
  doi          = {10.5281/zenodo.6331757},
  url          = {https://doi.org/10.5281/zenodo.6331757}
}
```
 -->

---

## Workflow

### Analysis Source Code

The source code for the analyses reported here can be found in the directory `scripts/`, and are explained briefly here:

- `scripts/01_xx.Rmd`: Process the output, in the form of _Rds_ objects, that result from running _Pathomove_ replicates or parameter combinations.

- `scripts/02_xx.Rmd`: Process the pairwise individual associations logged during the simulation into social networks.

- `scripts/03_xx.Rmd`: Run SIR models on the emergent social networks acquired from simulation runs.

**Add more scripts here**

---

## Figure Source Code

The source code for the figures in this manuscript is in the directory `figure_scripts/`. These scripts are well commented, and are not explained further.

### Figures

## Manuscript Text

The main text of the manuscript is written in LaTeX and is stored in the (private) submodule, `manuscript`.
Using the shell scripts provided in `bash/`, the LaTeX files are converted into date-stamped PDFs.
These are not uploaded here, but the `docs/` folder indicates their storage location.

## Supplementary Material

The supplementary material provided with this manuscript is generated from the `supplement/` directory.

**List supplementary files**

- Other files in this directory are helper files required to format the supplementary material.

## Other Directories

- `bash/` Some useful shell scripts for output rendering.

## Source Code for Figures and Analyses

### renv/

### scripts/
