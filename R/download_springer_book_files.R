#' Generate all pdf's in the directories organized by book type
#'
#' @importFrom dplyr filter pull
#' @importFrom janitor clean_names
#' @importFrom rlang .data
#' @importFrom tictoc tic toc
#'
#' @export
#'
download_springer_book_files <- function(springer_books_titles = NA, destination_folder = 'springer_quarantine_books', lan = 'eng') {

  springer_table <- download_springer_table(lan = lan)

  if (is.na(springer_books_titles)) {
    springer_books_titles <- springer_table %>%
      clean_names() %>%
      pull(.data$book_title) %>%
      unique()
  }

  n <- length(springer_books_titles)

  i <- 1

  message("Downloading title latest editions.")

  for (title in springer_books_titles) {

    message(paste0('Processing... ', title, ' (', i, ' out of ', n, ')'))

    book_type <-
      springer_table %>%
      filter(.data$book_title == title) %>%
      { if(lan == 'eng') pull(., .data$english_package_name) else .} %>%
      { if(lan == 'ger') pull(., .data$german_package_name) else .} %>%
      unique()

    current_folder = file.path(destination_folder, book_type)
    if (!dir.exists(current_folder)) { dir.create(current_folder, recursive = T) }
    setwd(current_folder)
    tic('Time processed')
    download_springer_book(title, springer_table)
    toc()
    setwd(file.path('.', '..', '..'))

    i <- i + 1

  }

}
