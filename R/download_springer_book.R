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
#' @importFrom utils download.file
#' @importFrom rlang .data
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
  function(book, destination_folder = 'springer_quarantine_books', springer_table = NULL) {

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
      dplyr::filter(.data$book_title == book) %>%
      dplyr::filter(.data$copyright_year == max(.data$copyright_year))

    edition <-
      book_info %>%
      dplyr::pull(.data$edition) %>%
      unique()

    en_book_type <-
      book_info %>%
      dplyr::pull(.data$english_package_name) %>%
      unique()

    clean_book_title <-
      gsub('/', '-', book)

    message(paste0('Downloading ', clean_book_title))

    dir.create(
      path = sprintf('%s/%s',
                     destination_folder,
                     en_book_type),
      showWarnings = FALSE,
      recursive = TRUE
    )

    if(nrow(book_info) == 1) {

      if(file.exists(
        sprintf(
          '%s/%s/%s - %s.pdf',
          destination_folder,
          en_book_type,
          clean_book_title,
          edition)
      )) {

        message('File already exists, skipping book download')

        return()

      } else {

        download_url <-
          book_info %>%
          dplyr::pull(.data$open_url) %>%
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

    } else {

      list_of_downloads <-
        book_info %>%
        dplyr::pull(.data$open_url)

      purrr::map(
        list_of_downloads,
        function(book_url) {

          url_info <-
            book_url %>%
            httr::GET()

          download_url <-
            url_info %>%
            magrittr::extract2('url') %>%
            stringr::str_replace('book', paste0('content', '/', 'pdf')) %>%
            stringr::str_replace('%2F', '/') %>%
            paste0('.pdf')

          subtitle <-
            url_info %>%
            httr::content() %>%
            rvest::html_nodes(xpath = '//*[@id="main-content"]/article[1]/div/div/div[1]/div/div/div[1]/div[2]/h2') %>%
            rvest::html_text()

          download.file(
            url = download_url,
            destfile = sprintf(
              '%s/%s/%s - %s - %s.pdf',
              destination_folder,
              en_book_type,
              clean_book_title,
              subtitle,
              edition
            ),
            quiet = TRUE
          )

          Sys.sleep(1)

        }

      )

    }

    t2 <- Sys.time()

    return_time <- t2 - t1

    message(paste0('Time Elapsed for ', clean_book_title, ': ', format(return_time, digits = 2)))

    return(return_time)

  }
