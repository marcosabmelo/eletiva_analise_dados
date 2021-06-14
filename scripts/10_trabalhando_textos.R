# ---------------------------------------------------------------------------------
# Trabalhando com Textos
# ---------------------------------------------------------------------------------
library(tidyverse)
library(pdftools)
library(textreadr)

# Texto com feriados 2021 PDF
feriados2021 <- read_pdf('documentos/feriados2021.pdf', ocr = T)

# Trocando barras por hífens
datas_hifen <- str_replace_all(string = feriados2021, pattern = "/", replacement = "-")

# Extraindo as datas dos feriados
(datas <- str_extract_all(datas_hifen[3], "\\d{1,2}[-]\\d{1,2}[-]\\d{1,2}"))