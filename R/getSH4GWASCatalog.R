#' @title Get unharmonised urls from GWAS Catalog
#'
#' @param accessionNumber An accession number
#'
#' @export
getUrlFromGWASCatalog <- function(accessionNumber) {
  ## Setup the fixed ftp website
  .url <- "https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics"
  ## Generate the access number range
  x <- as.numeric(gsub("GCST","",accessionNumber))/1000
  if (all(x%%1==0)) { genRange <- x-1 } else {genRange <- floor(x)}
  .url. <- paste("GCST",
                 c(genRange*1000+1,(genRange+1)*1000),
                 collapse="-",sep="")
  ## Generate the dataset
  url. <- paste(accessionNumber,"/",
                paste(accessionNumber,"_buildGRCh37.tsv.gz",sep=""),
                sep="")
  paste(.url,"/",.url.,"/",url.,sep="")
}

#' @title Generate a shell script for downloading summary-level data from GWAS Catalog
#' @param accessionNumberList The accession number or a vector of accession numbers
#' @export
getSH4GWASCatalog <- function(accessionNumberList) {
  ## Generate the url for downloading summary statistics from GWAS Catalog
  urls <- unlist(lapply(accessionNumberList,
                        FUN=function(i) {
                          aref <- getUrlFromGWASCatalog(i)
                          paste("wget ",aref," &",sep="")
                        } ))

  ## Generate shell script for downloading summary statistics in parallel
  ## This step is very useful when downloading multiple datasets
  aHead <- "!#/bin/bash"
  aEnd1 <- "wait"
  aEnd2 <- "echo 'All datasets are downloaded!'"
  datUrls <- rbind(data.frame(x=aHead),data.frame(x=urls),
                   data.frame(x=aEnd1),data.frame(x=aEnd2))
  return(datUrls)
}

#' @title Get harmonized urls given a accession number
#'
#' @param accessionNumberList A vector contains accession number lists
#'
#' @export
getHarmonizedUrlsFromGWASCatalog <- function(accessionNumberList) {
  urls <- unlist(
    lapply(accessionNumberList,
           FUN=function(i) {
             ## Setup the fixed ftp website
             .url <- "https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics"
             ## Generate the access number range
             x <- as.numeric(gsub("GCST","",i))/1000
             if (all(x%%1==0)) { genRange <- x-1 } else {genRange <- floor(x)}
             .url. <- paste("GCST",
                            c(genRange*1000+1,(genRange+1)*1000),
                            collapse="-",sep="")
             ## Generate the dataset
             url <- paste(.url,"/",.url.,"/",i,"/harmonised/",sep="")
             links <- getHttpsFromURL(url)
             links <- grep(".h.tsv.gz",links,value=TRUE)
             return(paste(url,links,sep=""))
           }))
  return(urls)
}


#' @title Generate a shell script for parallel downloading harmonised summary-level data from GWAS Catalog
#' @param accessionNumberList The accession number or a vector of accession numbers
#' @export
getSH4HarmonizedGWASCatalog <- function(accessionNumberList) {
  urls <- getHarmonizedUrlsFromGWASCatalog(accessionNumberList=accessionNumberList)
  url <- unlist(
    lapply(urls,FUN=function(x) {
      paste("wget ", x, " &", sep="")
    })
  )
  aHead <- "!#/bin/bash"
  aEnd1 <- "wait"
  aEnd2 <- "echo 'All datasets are downloaded!'"
  datUrls <- rbind(data.frame(x=aHead),
                   data.frame(x=url),
                   data.frame(x=aEnd1),
                   data.frame(x=aEnd2))
}

#' @title Generate a shell script for parallel downloading given a vector of urls
#' @param urls A vector of urls
#' @param outPath Path for saving the shell script
#' @export
generateSH <- function(urls,outPath) {
  urls <- ifelse(grepl("wget",urls),
                 paste(urls, " & ", sep=""),
                 paste("wget ", urls, " & ", sep=""))
  aHead <- "!#/bin/bash"
  aEnd1 <- "wait"
  aEnd2 <- "echo 'All datasets are downloaded!'"
  datUrls <- rbind(data.frame(x=aHead),data.frame(x=urls),
                   data.frame(x=aEnd1),data.frame(x=aEnd2))
  utils::write.table(
    datUrls,
    file=paste(outPath,"/downloadUrls.sh",sep=""),
    quote=FALSE,row.names=FALSE,col.names=FALSE
  )
}
