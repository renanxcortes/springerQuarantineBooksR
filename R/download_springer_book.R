#' Function that fetchs the pdf file and saves it in the current directory
#'
#' @importFrom dplyr arrange desc filter slice
#' @importFrom httr GET
#' @importFrom magrittr extract2 %>%
#' @importFrom rlang .data
#' @importFrom stringr str_replace
#'
#' @export
#'
download_springer_book <- function(book_spec_title, springer_table){

  file_sep <- .Platform$file.sep

  aux <- springer_table %>%
    filter(.data$book_title == book_spec_title) %>%
    arrange(desc(.data$copyright_year)) %>%
    slice(1)

  edition <- aux$edition

  download_url <- aux$open_url %>%
    GET() %>%
    extract2('url') %>%
    str_replace('book', paste0('content', file_sep, 'pdf')) %>%
    str_replace('%2F', file_sep) %>%
    paste0('.pdf')

  pdf_file = GET(download_url)

  clean_book_title <- str_replace(book_spec_title, '/', '-') # Avoiding '/' special character in filename
  clean_book_title <- str_replace(clean_book_title, ':', '-') # Avoiding ':' special character in filename

  write.filename = file(paste0(clean_book_title, " - ", edition, ".pdf"), "wb")
  writeBin(pdf_file$content, write.filename)
  close(write.filename)

}
