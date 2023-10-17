# Introduction to GALLO  

**Author:** Pablo Fonseca

**Date:** 05/02/21

## Table of contents
* [General info](#general-info)
* [Softwares](#softwares-and-packages)
* [Contact](#contact)

## General info
This is a repository for the files and codes used during the talk for the Advanced Statistical Methods in Animal Breeding (ASMAB) study group. 

This data repository is composed of the following folders:

- **data:** The data folder contains all the required datasets used for the analysis performed during the talk.

- **Presentation:** In this folder, you can find the presentation.

- **scripts:** The scripts with code used for the analysis performed in this talk are saved in this folder.

## Software and packages

For this talk, you will need to have installed in your computer the latest versions of R and RStudio. This software can be downloaded through the following links:

- **R:** https://vps.fmvz.usp.br/CRAN/

- **Rstudio:** https://rstudio.com/products/rstudio/download/

In addition to R and RStudio, you will also need to install some packages that will be required for the analysis. The list of packages used in this course can be found below. 

- *GALLO:* The Genomic Annotation in Livestock for positional candidate LOci (GALLO) is an R package designed to provide an intuitive and straightforward environment to annotate positional candidate genes and QTLs from high-throughput genetic studies in livestock

```{r global_options, include = FALSE}
install.packages("GALLO")
```
- *genomation:* A package for summary and annotation of genomic intervals.

```{r global_options, include = FALSE}
BiocManager::install("genomation")
```
- *visNetwork:*  a R package for network visualization, using vis.js javascript library.
  
```{r global_options, include = FALSE}
install.packages("visNetwork")
```
- *igraph:* Routines for simple graphs and network analysis. It can handle large graphs very well and provides functions for generating random and regular graphs, graph visualization, centrality methods and much more.
  
```{r global_options, include = FALSE}
install.packages("igraph")
```

## Contact

[![Gmail Badge](https://img.shields.io/badge/-pablofonseca.bio@gmail.com-c14438?style=flat-square&logo=Gmail&logoColor=white&link=mailto:pablofonseca.bio@gmail.com)](mailto:pablofonseca.bio@gmail.com)
[![Outlook Badge](https://img.shields.io/badge/-pfonseca@uoguelph.ca-0078d4?style=flat-square&logo=microsoft-outlook&logoColor=white&link=mailto:pfonseca@uoguelph.ca)](mailto:pfonseca@uoguelph.ca)
[![Google Scholar Badge](https://img.shields.io/badge/Google-Scholar-lightgrey)](https://scholar.google.com/citations?user=1VUm8EIAAAAJ&hl=pt-BR)
[![ResearchGate Badge](https://img.shields.io/badge/Research-Gate-9cf)](https://www.researchgate.net/profile/Pablo_Fonseca2)

<!-- display the social media buttons in your README -->

[![alt text][1.1]][1]
[![alt text][6.1]][6]


<!-- links to social media icons -->
<!-- no need to change these -->

<!-- icons with padding -->

[1.1]: http://i.imgur.com/tXSoThF.png (twitter icon with padding)
[6.1]: http://i.imgur.com/0o48UoR.png (github icon with padding)

<!-- icons without padding -->

[1.2]: http://i.imgur.com/wWzX9uB.png (twitter icon without padding)
[6.2]: http://i.imgur.com/9I6NRUm.png (github icon without padding)


<!-- links to your social media accounts -->
<!-- update these accordingly -->

[1]: http://www.twitter.com/pablo_bio
[6]: http://www.github.com/pablobio

<!-- Please don't remove this: Grab your social icons from https://github.com/carlsednaoui/gitsocial -->
