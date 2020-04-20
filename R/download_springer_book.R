# Function that fetchs the pdf file and saves it in the current directory

download_springer_book <-
  function(book, destination_folder = 'books', springer_table = NULL) {

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

    dir.create(
      path = sprintf('%s/%s',
                     destination_folder,
                     en_book_type),
      showWarnings = FALSE,
      recursive = TRUE
    )

    download_url <-
      book_info %>%
      dplyr::pull(open_url) %>%
      httr::GET() %>%
      magrittr::extract2('url') %>%
      stringr::str_replace('book', paste0('content', '/', 'pdf')) %>%
      stringr::str_replace('%2F', '/') %>%
      paste0('.pdf')

    clean_book_title <-
      gsub('/', '-', book)

    download.file(
      url = download_url,
      destfile = sprintf(
        '%s/%s/%s - %s.pdf',
        destination_folder,
        en_book_type,
        clean_book_title,
        edition
      )
    )

  }

