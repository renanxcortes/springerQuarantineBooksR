# Function that fetchs the pdf file and saves it in the current directory

download_springer_book <- function(book_spec_title, springer_table, filetype){

  file_sep <- .Platform$file.sep

  aux <- springer_table %>%
    filter(book_title == book_spec_title) %>%
    arrange(desc(copyright_year)) %>%
    slice(1)

  edition <- aux$edition
  en_book_type <- aux$english_package_name
  
  if(filetype == 'pdf'){
    dlpath <- 'content'
  }
  else if(filetype == 'epub'){
    dlpath <- 'download'
  }

  download_url <- aux$open_url %>%
    GET() %>%
    extract2('url') %>%
    str_replace('book', paste0(dlpath, file_sep, filetype)) %>%
    str_replace('%2F', file_sep) %>%
    paste0('.', filetype)

  pdf_file = GET(download_url)

  if(!http_error(pdf_file)){
    clean_book_title <- str_replace(book_spec_title, '/', '-') # Avoiding '/' special character in filename
    clean_book_title <- str_replace(clean_book_title, ':', '-') # Avoiding ':' special character in filename

    write.filename = file(paste0(clean_book_title, " - ", edition, ".", filetype), "wb")
    writeBin(pdf_file$content, write.filename)
    close(write.filename)
  }

}
