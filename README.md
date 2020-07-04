[![Build Status](https://travis-ci.com/am2222/nzdggs.svg?branch=master)](https://travis-ci.com/am2222/nzdggs) [![Documentation Status](https://readthedocs.org/projects/nzdggs/badge/?version=latest)](https://thespatiallabatlaurier.github.io/nzdggs/)

![Output Plot](docs/Examples/Rplot1.png)

# IDEAS
Manipulate and Run Analysis Using IDEAS data model, as described in  [Robertson et
al. 2020.](https://www.sciencedirect.com/science/article/pii/S0924271620300502).

# Nzdggs
Manipulate and Run Analysis on Netezza Using IDEAS Model


# Install

```r
devtools::install_github("thespatiallabatlaurier/nzdggs")

```

# Examples
 
- [Getting Started](https://thespatiallabatlaurier.github.io/nzdggs/Examples/GettingStarted/)
- [Convert and Importing Data](https://thespatiallabatlaurier.github.io/nzdggs/Examples/ImportData/convert_csv_to_dggs/)
- [Polygon To DGGS](https://thespatiallabatlaurier.github.io/nzdggs/Examples/ImportData/convert_polygon_to_dggs/)
- [.Nc to DGGS](https://thespatiallabatlaurier.github.io/nzdggs/Examples/ImportData/import_nc_file/)
- [API](https://thespatiallabatlaurier.github.io/nzdggs/)


# Documentations

```
https://thespatiallabatlaurier.github.io/nzdggs/
```


# Development
```
install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)
setwd("..\")
devtools::document()
#makedocs documentation
library(stringr)
files <- dir("E:/Personal/Lab/pkg/nzdggs/man/", pattern ="*.Rd")

lapply(files, function(x) {
  outfile = paste("E:/Personal/Lab/pkg/nzdggs/docs/",str_replace(x, ".Rd", ".md"),sep = "/")
  rdfile = paste("E:/Personal/Lab/pkg/nzdggs/man/",x,sep = "/")
  Rd2md::Rd2markdown(rdfile = rdfile, outfile = outfile)
  })

mkdocs gh-deploy -c -f ./mkdocs_material.yml
```
To make a tuturial

```r
# make your Rmd file
# then render it
library(rmarkdown)
render("vignettes//IDEAS-spatial-overlay.Rmd", md_document(variant = "markdown_github"))

# then copy it under proper directory under /docs/Examples/IDEAS
# push on the github
# Run mkdocs gh-deploy -c -f ./mkdocs_material.yml

```




