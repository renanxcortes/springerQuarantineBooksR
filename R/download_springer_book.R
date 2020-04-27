#' Download a Springer book.
#' 
#' @param book_spec_title book title from \code{\link{download_springer_table}}
#' @param springer_table table of available Springer books
#' @param dest_dir the directory to download the book to.
#' @export
download_springer_book <- function(book_spec_title, 
								   springer_table = download_springer_table(), 
								   dest_dir = getwd()) {
	
	file_sep <- .Platform$file.sep
	
	aux <- springer_table %>%
		filter(book_title == book_spec_title) %>%
		arrange(desc(copyright_year)) %>%
		slice(1)
	
	edition <- aux$edition
	en_book_type <- aux$english_package_name
	
	download_url <- aux$open_url %>%
		GET() %>%
		extract2('url') %>%
		str_replace('book', paste0('content', file_sep, 'pdf')) %>%
		str_replace('%2F', file_sep) %>%
		paste0('.pdf')
	
	pdf_file <- GET(download_url)
	
	clean_book_title <- str_replace(book_spec_title, '/', '-') # Avoiding '/' special character in filename
	
	write.filename <- file(paste0(dest_dir, file_sep, clean_book_title, " - ", edition, ".pdf"), "wb")
	writeBin(pdf_file$content, write.filename)
	close(write.filename)
	
}
