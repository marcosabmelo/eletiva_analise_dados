## QUI-QUADRADO COM R COM R ##
# Marcos A. B. de Melo
# 27/09/2023

# Carregando pacotes
pacman::p_load(corrplot, data.table, ggplot2)

# Base Breast Cancer
breast_cancer <- fread('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_tratadas/breast_cancer.csv', stringsAsFactors = T)
#breast_cancer <- fread('bases_tratadas/breast_cancer.csv', stringsAsFactors = T)

# Tabela de contingência: Tamanho de tumor e lado da mama
breast_cancer_table <- table(breast_cancer$tumor_tamanho, breast_cancer$breast)
breast_cancer_table

# Gráfico de barras
ggplot(breast_cancer) + aes(x = tumor_tamanho, fill = breast) + geom_bar(position = "fill")

# Teste Qui Quadrado
breast_cancer_test <- chisq.test(breast_cancer_table)
breast_cancer_test
breast_cancer_test$observed
breast_cancer_test$expected

# Corrplot das variáveis
corrplot(breast_cancer_test$residuals, is.cor = FALSE, method = "square")