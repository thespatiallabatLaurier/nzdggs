[![Build Status](https://travis-ci.com/am2222/nzdggs.svg?branch=master)](https://travis-ci.com/am2222/nzdggs) [![Documentation Status](https://readthedocs.org/projects/nzdggs/badge/?version=latest)](https://am2222.github.io/nzdggs/)

![Output Plot](docs/Examples/Rplot1.png)

# Nzdggs
Manipulate and Run Analysis on Netezza Using IDEAS Model


# Install

```r
devtools::install_github("am2222/nzdggs")

```

# Examples
 
- [Getting Started](https://am2222.github.io/nzdggs/Examples/GettingStarted/)
- [Convert and Importing Data](https://am2222.github.io/nzdggs/Examples/ImportData/convert_csv_to_dggs/)
- [Polygon To DGGS](https://am2222.github.io/nzdggs/Examples/ImportData/convert_polygon_to_dggs/)
- [.Nc to DGGS](https://am2222.github.io/nzdggs/Examples/ImportData/import_nc_file/)
- [API](https://am2222.github.io/nzdggs/)


# Documentations

```
https://nzdggs.readthedocs.io/en/latest/
```


# Development
```
install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)
setwd("..\")
devtools::document()
mkdocs gh-deploy  -f ./mkdocs_material.yml
#makedocs documentation
library(stringr)
files <- dir("E:/Personal/Lab/pkg/nzdggs/man/", pattern ="*.Rd")

lapply(files, function(x) {
  outfile = paste("E:/Personal/Lab/pkg/nzdggs/docs/",str_replace(x, ".Rd", ".md"),sep = "/")
  rdfile = paste("E:/Personal/Lab/pkg/nzdggs/man/",x,sep = "/")
  Rd2md::Rd2markdown(rdfile = rdfile, outfile = outfile)
  })


```
