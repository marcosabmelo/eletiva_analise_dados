# -----------------------------------------------------------------
# arquivos html
library(rvest)
library(dplyr)
# -----------------------------------------------------------------
# tabela wikipedia
url <- "https://pt.wikipedia.org/wiki/Medalha_Fields"
url_tabela <- url %>% read_html %>% html_nodes("table")
medalhistas_field <- as.data.frame(html_table(url_tabela[2]))
# -----------------------------------------------------------------