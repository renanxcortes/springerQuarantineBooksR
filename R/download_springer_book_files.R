# Generate all pdf's in the directories organized by book type

download_springer_book_files <- function(springer_books_titles = NA, springer_table = NA) {

  if (is.na(springer_table)) {
    springer_table <- download_springer_table()
  }

  if (is.na(springer_books_titles)) { springer_books_titles <- springer_table$`Book Title` %>% unique()}

  n <- length(springer_books_titles)

  i <- 1

  print("Downloading title latest editions.")

  for (title in springer_books_titles) {

    print(paste0('Processing... ', title, ' (', i, ' out of ', n, ')'))

    en_book_type <- springer_table %>%
      filter(`Book Title` == title) %>%
      pull(`English Package Name`) %>%
      unique()

    current_folder = file.path('springer_quarantine_books', en_book_type)
    if (!dir.exists(current_folder)) { dir.create(current_folder, recursive = T) }
    setwd(current_folder)
    tic('Time processed')
    download_springer_book(title, springer_table)
    toc()
    setwd(file.path('.', '..', '..'))

    i <- i + 1

  }

}
