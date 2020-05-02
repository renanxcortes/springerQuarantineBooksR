#' Download the springer table file
#'
#' \code{download_springer_table} This function downloads the springer table of all books available.
#'
#' @param lan The language of the downloaded books. Can be either set to 'eng' (English) or 'ger' (German). Default is 'eng'.
#'
#' @importFrom httr GET write_disk
#' @importFrom readxl read_excel
#'
#' @export
#'
download_springer_table <-
  function(lan = 'eng') {

    `%>%` <- magrittr::`%>%`

    if (lan == 'eng') {books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'}
    if (lan == 'ger') {books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17863240/data/v2'}

    GET(books_list_url, write_disk(tf <- tempfile(fileext = ".xlsx")))

    springer_table <- read_excel(tf) %>%
      clean_names()

    return(springer_table)

  }
