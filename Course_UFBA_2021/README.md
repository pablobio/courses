# Analyzing functional data using R  

**Author:** Pablo Fonseca

**Date:** 05/02/21

## Table of contents
* [General info](#general-info)
* [Softwares](#softwares-and-packages)
* [Contact](#contact)

## General info
This is a repository for the files and codes used for the course "Análises de dados funcionais usando o R" presented as part of the event "Aplicabilidades de Softwares em análises genômicas" (http://www.emevz.ufba.br/aplicabilidade-de-softwares-em-analises-genomicas). 

In this course we will cover some relevant tools for the identification of functional canidate genes and candidate functional variant selection. Among these tools we will discuss the use of Gene Ontology, MeSH, Metabolic pathways and Quantitative Trait Loci (QTL) annotation (and enrichment analysis). Additionally, we will discuss the importance of data integration and the use of tools for data summary, comparison and visualization. 

This data respository is composed by the following folders:

- **data:** The data folder contains all the required datasets used for the analysis performed during this course.

- **presentations:** In this folder, you can find the presentations used for theoretical discussion during the course.

- **scripts:** The scripts with code used for the analysis performed in this course are saved in this folder.

## Softwares and packages

For this course you will need to have installed in your computer the latest versions of R and RStudio. This softwares can be downloaded in the following links:

- **R:** https://vps.fmvz.usp.br/CRAN/

- **Rstudio:** https://rstudio.com/products/rstudio/download/

In addition to R and RStudio, you will also need to install some packages that will be required for the analysis. The list of packages used in this course can be find below. 

- *BiocManager:* The BiocManager package will be used to install those package which are deposited in the Bioconductor repository. In case you do not have BiocManager installed in your R version, please, intall it using the following code.

```{r global_options, include = FALSE}
install.packages("BiocManager")
```

- *biomaRt:* The package enables retrieval of large amounts of data in a uniform way without the need to know the underlying database schemas or write complex SQL queries. The most prominent examples of BioMart databases are maintain by Ensembl, which provides biomaRt users direct access to a diverse set of data and enables a wide range of powerful online queries from gene annotation to database mining.

```{r global_options, include = FALSE}
BiocManager::install("biomaRt")
```

- *GALLO:* The Genomic Annotation in Livestock for positional candidate LOci (GALLO) is an R package designed to provide an intuitive and straightforward environment to annotate positional candidate genes and QTLs from high-throughput genetic studies in livestock

```{r global_options, include = FALSE}
install.packages("GALLO")
```

- *WebGestaltR:* The web version WebGestalt <http://www.webgestalt.org> supports 12 organisms, 354 gene identifiers and 321,251 function categories. Users can upload the data and functional categories with their own gene identifiers. In addition to the Over-Representation Analysis, WebGestalt also supports Gene Set Enrichment Analysis and Network Topology Analysis. The user-friendly output report allows interactive and efficient exploration of enrichment results. The WebGestaltR package not only supports all above functions but also can be integrated into other pipeline or simultaneously analyze multiple gene lists.

```{r global_options, include = FALSE}
install.packages("WebGestaltR")
```

- *meshes:* MeSH (Medical Subject Headings) is the NLM controlled vocabulary used to manually index articles for MEDLINE/PubMed. MeSH terms were associated by Entrez Gene ID by three methods, gendoo, gene2pubmed and RBBH. This association is fundamental for enrichment and semantic analyses. meshes supports enrichment analysis (over-representation and gene set enrichment analysis) of gene list or whole expression profile. The semantic comparisons of MeSH terms provide quantitative ways to compute similarities between genes and gene groups. meshes implemented five methods proposed by Resnik, Schlicker, Jiang, Lin and Wang respectively and supports more than 70 species.

```{r global_options, include = FALSE}
install.packages("meshes")
```

- *MeSH.Bta.eg.db:* Mapping table for Bos taurus Gene ID to MeSH.

```{r global_options, include = FALSE}
install.packages("MeSH.Bta.eg.db")
```

- *STRINGdb:* The STRINGdb package provides a R interface to the STRING protein-protein interactions database (https://www.string-db.org).

```{r global_options, include = FALSE}
BiocManager::install("STRINGdb")
```

## Contact

[![Gmail Badge](https://img.shields.io/badge/-Gmail-c14438?style=flat-square&logo=Gmail&logoColor=white&link=mailto:seu_email)](mailto:pfonseca@uoguelph.ca)

<!-- display the social media buttons in your README -->

[![alt text][1.1]][1]
[![alt text][2.1]][2]
[![alt text][6.1]][6]


<!-- links to social media icons -->
<!-- no need to change these -->

<!-- icons with padding -->

[1.1]: http://i.imgur.com/tXSoThF.png (twitter icon with padding)
[2.1]: ![] (https://upload.wikimedia.org/wikipedia/commons/2/28/Google_Scholar_logo.png | width=100x200)
[6.1]: http://i.imgur.com/0o48UoR.png (github icon with padding)

<!-- icons without padding -->

[1.2]: http://i.imgur.com/wWzX9uB.png (twitter icon without padding)
[6.2]: http://i.imgur.com/9I6NRUm.png (github icon without padding)


<!-- links to your social media accounts -->
<!-- update these accordingly -->

[1]: http://www.twitter.com/pablo_bio
[2]: https://scholar.google.com/citations?user=1VUm8EIAAAAJ&hl=pt-BR
[6]: http://www.github.com/pablobio

<!-- Please don't remove this: Grab your social icons from https://github.com/carlsednaoui/gitsocial -->
