#' Function that fetchs the pdf/epub file and saves it in the current directory
#'
#' \code{download_springer_book} Downloads a single book from the Springer open repository.
#'
#' @param book_spec_title The title of the book to be downloaded.
#' @param dspringer_table The table where 'book_spec_title' should be downloaded from.
#' @param filetype The file type extension of the books downloaded. Can be either set to 'pdf', 'epub' or 'both'. Default is 'pdf'.
#'
#' @importFrom dplyr arrange desc filter slice
#' @importFrom httr GET http_error
#' @importFrom magrittr extract2 %>%
#' @importFrom rlang .data
#' @importFrom stringr str_replace str_replace_all
#'
#' @export
#'
download_springer_book <- function(book_spec_title, springer_table, filetype){

  `%>%` <- magrittr::`%>%`

  file_sep <- .Platform$file.sep

  aux <- springer_table %>%
    filter(.data$book_title == book_spec_title) %>%
    arrange(desc(.data$copyright_year)) %>%
    slice(1)

  edition <- aux$edition

  if (filetype == 'pdf') { dlpath <- 'content' }
  if (filetype == 'epub') { dlpath <- 'download' }


  download_url <- aux$open_url %>%
    GET() %>%
    extract2('url') %>%
    str_replace('book', paste0(dlpath, file_sep, filetype)) %>%
    str_replace('%2F', file_sep) %>%
    paste0('.', filetype)

  clean_book_title <- str_replace_all(book_spec_title, '/', '-')  # Avoiding '/' special character in filename
  clean_book_title <- str_replace_all(clean_book_title, ':', '-') # Avoiding ':' special character in filename

  file_name_string <- paste0(clean_book_title, " - ", edition, ".", filetype)

  if (file.exists(file_name_string)) { message('File already exists, skipping book download') }

  else {

    get_file = GET(download_url, set_cookies(`recaptcha` = ""))

    if(!http_error(get_file)){

      write.filename = file(file_name_string, "wb")
      writeBin(get_file$content, write.filename)
      close(write.filename)
    }

  }
}
