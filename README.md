
# getSH4GWASCatalog

<!-- badges: start -->
<!-- badges: end -->

The goal of getSH4GWASCatalog is to generate a shell script for downloading summary statistics from GWAS Catalog <https://www.ebi.ac.uk/gwas/home>

## Installation

You can install the development version of getSH4GWASCatalog like so:

``` r
library(devtools)
devtools::install_github("yangzhao98/getSH4GWASCatalog")
library(getSH4GWASCatalog)
```

## Donwload unharmonised summary statistics from GWAS Catalog using its \code{API}

1. Find the accession number of a specific study, e.g., \code{accessionNum="GCST90002000"}
``` r
accessionNumber <- "GCST90002000"
```

2. Get the *url* for downloading the unharmonised summary statistics
``` r
url <- getSH4GWASCatalog("GCST90002000")
```

3. Write up a *shell script*, e.g., *test.sh*
``` r
curPath <- this.path::this.dir()
write.table(url,file=paste(curPath,"/donwloadUrl.sh",sep=""),
            quote=FALSE,row.names=FALSE,col.names=FALSE)
```

4. Process the *text.sh* for executing in **terminal**
``` r
dos2unix downloadUrl.sh | ./downloadUrl.sh
```





## Get all links from a website

``` r
getHttpsFrom(url="https://pheweb.jp/downloads")[1:5]
```
