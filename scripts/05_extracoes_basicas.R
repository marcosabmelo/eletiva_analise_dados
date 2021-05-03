# --------------------------------------------------------------------------------------------
# Extração de arquivos em diversos formatos
#
# arquivos csv
alunos_recife_2019_raw <- read.csv2("http://dados.recife.pe.gov.br/dataset/ce5168d4-d925-48f5-a193-03d4e0f587c7/resource/3b03a473-8b20-4df4-8628-bec55541789e/download/situacaofinalalunos2019.csv", sep = ';', encoding = 'UTF-8')
#
# arquivos json
#install.packages('rjson')
library(rjson)
#
alunos_recife_metadados <- fromJSON(file= "http://dados.recife.pe.gov.br/dataset/ce5168d4-d925-48f5-a193-03d4e0f587c7/resource/fb09086d-5df2-48d6-b868-acb00513fab1/download/situacao-final-dos-alunos-por-periodo-letivo.json" )
#
alunos_recife_metadados <- as.data.frame(alunos_recife_metadados)
#
# arquivos xml
#install.packages('XML')
library(XML)
#
ebay_auction <- xmlToDataFrame("http://aiweb.cs.washington.edu/research/projects/xmltk/xmldata/data/auctions/ebay.xml")
# --------------------------------------------------------------------------------------------