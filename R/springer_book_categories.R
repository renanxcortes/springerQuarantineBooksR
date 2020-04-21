#' List of springer book categories
#'
#' \code{springer_book_categories} This function returns a tibble that contains the categories used by springer to classify its books.
#' It can be used to filter book categories to download in `download_springer_book_files()` function.
#'
#' This is a void function, no arguments are passed to it
#'
#' @return The return of this function is a tibble containing Springer categories
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' springer_book_categories()
#' }
#'
springer_book_categories <-
  function() {

    `%>%` <- magrittr::`%>%`

    books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'

    httr::GET(books_list_url, httr::write_disk(tf <- tempfile(fileext = ".xlsx")))

    springer_table <-
      readxl::read_excel(tf) %>%
      janitor::clean_names()

    tbl_return <-
      springer_table %>%
      dplyr::select(categories = .data$english_package_name) %>%
      dplyr::distinct()

    return(tbl_return)

  }
