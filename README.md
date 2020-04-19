# springerQuarantineBooksR: download all Springer books made available during the COVID-19 quarantine

Para construir a imagem deste aplicativo, navegue até a pasta raiz dele e rode o seguinte comando:

```
devtools::install_github("renanxcortes/springerQuarantineBooksR")
library(springerQuarantineBoksR)

setwd('path_of_your_choice')

tic('Total time: ')
generate_springer_book_files()
toc()
```

This is an R version of the https://github.com/alexgand/springer_free_books.