# Download the springer table file

download_springer_table <-
  function() {

    books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'

    httr::GET(books_list_url, httr::write_disk(tf <- tempfile(fileext = ".xlsx")))

    springer_table <- readxl::read_excel(tf)

    return(springer_table)

  }
