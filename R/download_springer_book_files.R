#' Generate all pdf's in the directories organized by book type
#'
#' @param springer_book_titles character vector of books to download. If not specified, all books will be downloaded.
#' @param springer_table table of available books to download.
#' @param destination_folder folder to save the books to.
download_springer_book_files <- function(springer_books_titles = NA, springer_table = NA, destination_folder = 'springer_quarantine_books') {

  if (is.na(springer_table)) {
    springer_table <- springerQuarantineBooksR::download_springer_table()
  }

  if (is.na(springer_books_titles)) { springer_books_titles <- springer_table %>%
    clean_names() %>%
    pull(book_title) %>%
    unique()}

  n <- length(springer_books_titles)

  i <- 1

  print("Downloading title latest editions.")

  for (title in springer_books_titles) {

    print(paste0('Processing... ', title, ' (', i, ' out of ', n, ')'))

    en_book_type <- springer_table %>%
      filter(book_title == title) %>%
      pull(english_package_name) %>%
      unique()

    current_folder <- file.path(destination_folder, en_book_type)
    if (!dir.exists(current_folder)) { dir.create(current_folder, recursive = T) }
    tic('Time processed')
    springerQuarantineBooksR::download_springer_book(title, springer_table, dest_dir = current_folder)
    toc()
    
    i <- i + 1

  }

}
