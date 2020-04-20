# Generate all pdf's in the directories organized by book type

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
      ~download_springer_book(
        book = .x,
        destination_folder = destination_folder,
        springer_table = springer_table
      )
    )

    future::plan(future::sequential)

  } else {

    purrr::walk(
      springer_books_to_download,
      ~download_springer_book(
        book = .x,
        destination_folder = destination_folder,
        springer_table = springer_table
      )

    )

  }

}
