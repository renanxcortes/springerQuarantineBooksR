# `springerQuarantineBooksR`: download all Springer books made available during the COVID-19 quarantine

## Installation

Having `devtools` installed and loaded, you can install `springerQuarantineBooksR` with the following code:

```
devtools::install_github("renanxcortes/springerQuarantineBooksR")
library(springerQuarantineBooksR)
```

## Download all books in any repo of your choice:

```
setwd('path_of_your_choice')

tic('Total time: ')
generate_springer_book_files()
toc()
```

## Download specific books only:

If you'd like to download only Books related with "Data Science" on the title, for example, you can run:

```
books_list_url <- 'https://resource-cms.springernature.com/springer-cms/rest/v1/content/17858272/data/v4/'
GET(books_list_url, write_disk(tf <- tempfile(fileext = ".xlsx")))
springer_table <- read_excel(tf)

specific_title_list <- springer_table %>% 
  filter(str_detect(`Book Title`, 'Data Science')) %>% 
  pull(`Book Title`)

generate_springer_book_files(specific_title_list)
```

# Acknowledgments

This is an R version of the `springer_free_books` project available at https://github.com/alexgand/springer_free_books.