#' Downloads multiple springer books, allowing filters of book groups
#'
#' \code{download_springer_book_files} This function can receive many arguments that will be used to download books from
#' the Springer open repository, it can receive a list of the names of the books that the user want to download,
#' it can receive a specific group of books to be downloaded, such as engineering, psycology, etc. (the list of available categories
#' can be found by running the `springer_book_categories()` function), if provided, it'll use a specific springer table to source
#' the url and book specifications, it also can receive a destination folder, and an argument that will allow the user to
#' run this in parallel through future.
#'
#' @param springer_books_titles A list of books to be downloaded, if left empty, it'll download every book.
#' @param springer_book_group A list of groups which to download books from (the default list can be found at `springer_book_categories()`),
#' if left empty, it'll download books from every category
#' @param springer_table The default table exported from springer website, if left empty, will source the provided table in web.
#' @param destination_folder A folder/path that will be used to save the files.
#' @param parallel A boolean which the user can choose to run the supplied function in parallel or not.
#'
#' @return The function will download the pdf of the books listed/provided, export it at the provided destination folder, and there are no
#' returns for this function
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' download_springer_book_files()
#' }
#'
download_springer_book_files <- function(springer_books_titles = NULL,
                                         springer_book_group = NULL,
                                         springer_table = NULL,
                                         destination_folder = 'books',
                                         parallel = FALSE) {

  `%>%` <- magrittr::`%>%`

  if (is.null(springer_table)) {

    books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'

    httr::GET(books_list_url, httr::write_disk(tf <- tempfile(fileext = ".xlsx")))

    springer_table <-
      readxl::read_excel(tf) %>%
      janitor::clean_names()

  }

  if (is.null(springer_books_titles) & is.null(springer_book_group)) {

    springer_books_to_download <-
      springer_table %>%
      dplyr::pull(book_title) %>%
      unique()

  } else if (is.null(springer_books_titles) & is.null(springer_book_group)) {

    springer_books_to_download <-
      springer_table %>%
      dplyr::filter(
        english_package_name %in% springer_book_group
      ) %>%
      dplyr::pull(book_title) %>%
      unique()

  } else {

    springer_books_to_download <-
      springer_books_titles

  }

  print("Downloading title latest editions.")

  if(parallel) {

    future::plan(future::multisession)

    furrr::future_map(
      springer_books_to_download,
      ~springerQuarantineBooksR::download_springer_book(
        book = .x,
        destination_folder = destination_folder,
        springer_table = springer_table
      )
    )

    future::plan(future::sequential)

  } else {

    purrr::walk(
      springer_books_to_download,
      ~springerQuarantineBooksR::download_springer_book(
        book = .x,
        destination_folder = destination_folder,
        springer_table = springer_table
      )

    )

  }

}
