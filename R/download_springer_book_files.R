#' Download all pdf's/epub's in the directories organized by book type
#'
#' \code{download_springer_book_files} This function can receive many arguments that will be used to download books from
#' the Springer open repository.
#'
#' @param springer_books_titles A list of books to be downloaded, if left empty, it'll download every book.
#' @param destination_folder A folder/path that will be used to save the files.
#' @param lan The language of the downloaded books. Can be either set to 'eng' (English) or 'ger' (German). Default is 'eng'.
#' @param filetype The file type extension of the books downloaded. Can be either set to 'pdf', 'epub' or 'both'. Default is 'pdf'.
#'
#' @importFrom dplyr filter pull
#' @importFrom janitor clean_names
#' @importFrom rlang .data
#'
#' @export
#'
download_springer_book_files <- function(springer_books_titles = NA, destination_folder = 'springer_quarantine_books', lan = 'eng', filetype = 'pdf') {

  if (!(filetype %in% c('pdf', 'epub', 'both'))) { stop("'filetype' should be 'pdf', 'epub' or 'both'.") }

  `%>%` <- magrittr::`%>%`

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
    
    if(is.na(title)){
      message("NA title found. Skipping it.")
      i <- i + 1
      next()
    }
    
    book_type <-
      springer_table %>%
      filter(.data$book_title == title) %>%
      { if(lan == 'eng') pull(., .data$english_package_name) else .} %>%
      { if(lan == 'ger') pull(., .data$german_package_name) else .} %>%
      unique()

    current_folder = file.path(destination_folder, book_type)
    if (!dir.exists(current_folder)) { dir.create(current_folder, recursive = T) }

    setwd(current_folder)
    t0 <- Sys.time()

    if(filetype == 'pdf' || filetype == 'epub') {
      download_springer_book(title, springer_table, filetype)
    }
    if (filetype == 'both') {
      download_springer_book(title, springer_table, 'pdf')
      download_springer_book(title, springer_table, 'epub')
    }

    print(paste0('Time processed: ', round(Sys.time() - t0, 2), ' sec elapsed'))
    setwd(file.path('.', '..', '..'))

    i <- i + 1

  }

}
