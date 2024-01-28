#' @title Generate a shell script for downloading summary-level data from GWAS Catalog
#' @param accessionNumberList The accession number or a vector of accession numbers
#' @export
getSH4GWASCatalog <- function(accessionNumberList) {
  ## Generate the url for downloading summary statistics from GWAS Catalog
  getUrlFromGWASCatalog <- function(accessionNumber) {
    ## Setup the fixed ftp website
    .url <- "https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics"
    ## Generate the access number range
    genRange <- floor(as.numeric(gsub("GCST","",accessionNumber))/1000)
    .url. <- paste("GCST",
                   c(genRange*1000+1,(genRange+1)*1000),
                   collapse="-",sep="")
    ## Generate the dataset
    url. <- paste(accessionNumber,"/",
                  paste(accessionNumber,"_buildGRCh37.tsv.gz",sep=""),
                  sep="")
    paste(.url,"/",.url.,"/",url.,sep="")
  }

  urls <- unlist(lapply(accessionNumberList,
                        FUN=function(i) {
                          aref <- getUrlFromGWASCatalog(i)
                          paste("wget ",aref," &",sep="")
                        } ))

  ## Generate shell script for downloading summary statistics in parallel
  ## This step is very useful when downloading multiple datasets
  aHead <- "!#/bin/bash"
  aEnd1 <- "wait &"
  aEnd2 <- "echo All datasets are downloaded"
  datUrls <- rbind(data.frame(x=aHead),data.frame(x=urls),
                   data.frame(x=aEnd1),data.frame(x=aEnd2))
  return(datUrls)
}
