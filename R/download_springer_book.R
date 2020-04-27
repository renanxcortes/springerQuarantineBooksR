# Function that fetchs the pdf file and saves it in the current directory

download_springer_book <- function(book_title, springer_table){

  file_sep <- .Platform$file.sep

  aux <- springer_table %>%
    filter(book_title == book_title) %>%
    arrange(desc(copyright_year)) %>%
    slice(1)

  edition <- aux$edition
  en_book_type <- aux$english_package_name

  download_url <- aux$OpenURL %>%
    GET() %>%
    extract2('url') %>%
    str_replace('book', paste0('content', file_sep, 'pdf')) %>%
    str_replace('%2F', file_sep) %>%
    paste0('.pdf')

  pdf_file = GET(download_url)

  clean_book_title <- str_replace(book_title, '/', '-') # Avoiding '/' special character in filename

  write.filename = file(paste0(clean_book_title, " - ", edition, ".pdf"), "wb")
  writeBin(pdf_file$content, write.filename)
  close(write.filename)

}
