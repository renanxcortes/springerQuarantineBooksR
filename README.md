# `springerQuarantineBooksR`: download all Springer books made available during the COVID-19 quarantine

**"With the Coronavirus outbreak having an unprecedented impact on education, Springer Nature is launching a global program to support learning and teaching at higher education institutions worldwide."**

**Source:** https://group.springernature.com/gp/group/media/press-releases/freely-accessible-textbook-initiative-for-educators-and-students/17858180?utm_medium=social&utm_content=organic&utm_source=facebook&utm_campaign=SpringerNature_&sf232256230=1

This package has the `download_springer_book_files` function which can be used to download all (or a subset) of these Springer book files freely available. Currently, it fetches only the pdf versions of the books and generates a repo with 7.27GB, if all books are downloaded.

*This is still a work in progress. Thus, any help and/or feedbacks are welcome!*

## Installation

Assuming you have [devtools](https://github.com/r-lib/devtools) installed, you can install `springerQuarantineBooksR` with the following code:

```
devtools::install_github("renanxcortes/springerQuarantineBooksR")
library(springerQuarantineBooksR)
```

## Download all books in any repo of your choice:

```
setwd('path_of_your_choice')
download_springer_book_files()
```

You'll get an output similar like this:

![](www/processing_example.png)

You can also download the files in parallel:

```
download_springer_book_files(parallel = TRUE)
```

## Repo Structure generated

It will be generated a repo named `springer_quarantine_books` with a specific structure:

![](www/directory_org_example.png)

## Download table of Springer books available:

If the user wants to load into an R session the table contaning all the titles available by Springer, there is the `download_springer_table` function.

```
springer_table <- download_springer_table()
```

## Download only specific books:

For example, if you'd like to download only books with "Data Science" on the title, you can run:

```
springer_table <- download_springer_table()

specific_titles_list <- springer_table %>% 
  filter(str_detect(`Book Title`, 'Data Science')) %>% 
  pull(`Book Title`)

download_springer_book_files(springer_books_titles = specific_titles_list)
```

## Download the list of book categories available:

In the `download_springer_book_files` function, one argument is the book category that the user might want to download. To know what are the categories available to be used in this argument, the user can run the `springer_book_categories` function, that will return a tibble containing that information.

# Acknowledgments

This project draw inspiration from the `springer_free_books` project available at https://github.com/alexgand/springer_free_books.

Thank you, Springer!
