# Generate all pdf's in the directories organized by book type

generate_pdf_files <- function(springer_books_titles = NA, springer_table = NA) {

if (is.na(springer_table)) {
  books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'
  GET(books_list_url, write_disk(tf <- tempfile(fileext = ".xlsx")))
  springer_table <- read_excel(tf)
}

if (is.na(springer_books_titles)) { springer_books_titles <- springer_table$`Book Title`}

n <- length(springer_books_titles)

i <- 1

for (title in springer_books_titles) {

  print(paste0('Processing... ', title, ' (', i, ' out of ', n, ')'))

  en_book_type <- springer_table %>%
    filter(`Book Title` == title) %>%
    pull(`English Package Name`)

  current_folder = file.path('springer_downloads', en_book_type)
  if (!dir.exists(current_folder)) { dir.create(current_folder, recursive = T) }
  setwd(current_folder)
  tic(paste0('Time processed of', title))
  fecth_single_pdf(title, springer_table)
  toc()
  setwd(file.path('.', '..', '..'))

  i <- i + 1

}

}
