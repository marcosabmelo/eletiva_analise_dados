# chamando biblioteca tidyverse
library("tidyverse")

# ampliando base de dados sobre veículos (base nativa do R - mtcars)
base_carros <- mtcars %>%
  select(consumo = mpg, cilindros = cyl, potencia = hp, peso = wt) %>%
  mutate(consumo = consumo*0.4251428571, potencia = round(potencia*1.01387)) # convertendo medidas
# milhas por galao para km por litro e hp para cv

# criando uma função para padronizar uma variável
padronizar = function(a) {
  if (is.numeric(a) == FALSE) {
    print("Variável não é numérica")
  } else {
    a <- (a-mean(a))/sd(a)
    return(a)
  }
}

# iniciando janela (2,2)
par(mfrow = c(2, 2))

# setando uma semente
set.seed(417)

# usando apply para preservar a estrutura de data frame
base_carros_padrao <- apply(base_carros, 2, padronizar)

# forcando data frame para poder usar a funcao rename
base_carros_padrao <- as.data.frame(base_carros_padrao)

# renomeando as variáveis da base de carros padrao. Ajuda a comparar os histogramas
base_carros_padrao <- base_carros_padrao %>%
  rename(consumo_padrao = consumo, cilindros_padrao = cilindros, potencia_padrao = potencia, peso_padrao = peso)

# setar a variavel temporaria antes é melhor
temp <- bind_cols(base_carros, base_carros_padrao)

# plotando os histogramas da 'melhor' forma possível com loop
for (i in c(0, 2)) {
  for (j in c(1, 5, 2, 6)) { #loop duplo para colocar cada variável ao lado da padrão
    hist(temp[ , i+j],       # ficaria mais simples se bind_cols funcionasse coluna a coluna
         main = names(temp)[i+j],
         xlab = "Valores",
         ylab = 'Frequência',
         xlim = c(min(temp[ , i+j]), max(temp[ , i+j])))
  } 
  par(mfrow = c(2, 2)) # prepara a tela para mais quatro gráficos
}
