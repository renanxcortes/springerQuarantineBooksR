#' Download a single book from Springer open book repository
#'
#' \code{download_springer_book} Get's a book name, and a default springer table that will be used to get the book's url.
#' Also, it saves the pdf in a specific destination folder mentioned in the function's arguments.
#'
#'
#' @param book The name of the book that will be downloaded, it has to be compliant to the springer table that will be provided.
#' @param destination_folder A folder/path that will be used to save the files.
#' @param springer_table The default table exported from springer website, if left empty, will source the provided table in web.
#'
#' @return The function will download the pdf of the book, export it at the provided destination folder, and return
#' the time it took to download the file
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' download_springer_book(book = "Fundamentals of Power Electronics")
#' }
#'
download_springer_book <-
  function(book, destination_folder = 'books', springer_table = NULL) {

    t1 <- Sys.time()

    `%>%` <- magrittr::`%>%`

    if(is.null(springer_table)) {

      books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'

      httr::GET(books_list_url, httr::write_disk(tf <- tempfile(fileext = ".xlsx")))

      springer_table <-
        readxl::read_excel(tf) %>%
        janitor::clean_names()

    }

    book_info <-
      springer_table %>%
      dplyr::filter(book_title == book) %>%
      dplyr::filter(copyright_year == max(copyright_year))

    edition <-
      book_info %>%
      dplyr::pull(edition)

    en_book_type <-
      book_info %>%
      dplyr::pull(english_package_name)

    clean_book_title <-
      gsub('/', '-', book)

    dir.create(
      path = sprintf('%s/%s',
                     destination_folder,
                     en_book_type),
      showWarnings = FALSE,
      recursive = TRUE
    )

    if(file.exists(sprintf(
      '%s/%s/%s - %s.pdf',
      destination_folder,
      en_book_type,
      clean_book_title,
      edition))) {

      message('File already exists, skipping book download')

      return()

    } else {

      download_url <-
        book_info %>%
        dplyr::pull(open_url) %>%
        httr::GET() %>%
        magrittr::extract2('url') %>%
        stringr::str_replace('book', paste0('content', '/', 'pdf')) %>%
        stringr::str_replace('%2F', '/') %>%
        paste0('.pdf')

      download.file(
        url = download_url,
        destfile = sprintf(
          '%s/%s/%s - %s.pdf',
          destination_folder,
          en_book_type,
          clean_book_title,
          edition
        ),
        quiet = TRUE
      )

      Sys.sleep(1)

    }

    t2 <- Sys.time()

    return_time <- t2 - t1

    message(paste0('Book: ', clean_book_title))
    message(paste0('Time Elapsed: ', format(return_time, digits = 2)))

    return(return_time)

  }
