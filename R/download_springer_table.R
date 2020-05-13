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

    if (!(lan %in% c('eng', 'ger'))) { stop("'lan' should be either 'eng' or 'ger'.") }

    `%>%` <- magrittr::`%>%`

    if (lan == 'eng') {

      books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v6/'
      GET(books_list_url, write_disk(tf <- tempfile(fileext = ".xlsx")))
      springer_table <- read_excel(tf) %>%
        clean_names()

      }

    if (lan == 'ger') {

      # springer_table1: original German books
      # springer_table2: medical and nursing German books
      # More details in https://github.com/renanxcortes/springerQuarantineBooksR/issues/16#issuecomment-621004526

      books_list_url1 <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17863240/data/v2'
      GET(books_list_url1, write_disk(tf1 <- tempfile(fileext = ".xlsx")))
      springer_table1 <- read_excel(tf1) %>%
        clean_names()

      books_list_url2 <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17856246/data/v3'
      GET(books_list_url2, write_disk(tf2 <- tempfile(fileext = ".xlsx")))
      springer_table2 <- read_excel(tf2) %>%
        clean_names()

      springer_table <- bind_rows(springer_table1, springer_table2)

    }

    return(springer_table)

  }
