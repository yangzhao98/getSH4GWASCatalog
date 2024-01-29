#' @title Get all links from a url
#'
#' @param url The url of a website
#'
#' @export
getHttpsFromURL <- function(url) {
  links <- rvest::html_attr(
    rvest::html_nodes(
      rvest::read_html(httr::content(httr::GET(url),"text")),"a"),"href")
  return(links)
}
