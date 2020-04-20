#' Download the springer table file
#'
#' \code{download_springer_table} This function returns a tibble containg the table provided by springer of all
#' of theri books that are openly accessible because of the COVID-19 quarantine
#'
#' @param save_locally A boolean value that, if is set to TRUE, will save in the current directory the springer table
#' in the RDS format
#'
#' @return The return of this function is a tibble containing the Springer table
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' download_springer_table()
#' }
#'
download_springer_table <-
  function(save_locally = FALSE) {

    `%>%` <- magrittr::`%>%`

    books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'

    httr::GET(books_list_url, httr::write_disk(tf <- tempfile(fileext = ".xlsx")))

    springer_table <-
      readxl::read_excel(tf) %>%
      janitor::clean_names()

    if(save_locally) {

      readr::write_rds(springer_table, paste0('springer_table_', Sys.Date(), '.rds'))

    }

    return(springer_table)

  }
