# springerQuarantineBooksR: download all Springer books made available during the COVID-19 quarantine

Intall the package and the following code:

```
devtools::install_github("renanxcortes/springerQuarantineBooksR")
library(springerQuarantineBoksR)

setwd('path_of_your_choice')

tic('Total time: ')
generate_springer_book_files()
toc()
```

This is an R version of the https://github.com/alexgand/springer_free_books.