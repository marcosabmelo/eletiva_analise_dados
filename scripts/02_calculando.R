# Chamando biblioteca tidyverse
library("tidyverse")

# base de dados sobre consumo dos veículos (base nativa do R - mtcars)
base_carros <- mtcars %>%
  select(consumo = mpg, potencia = hp) %>%
  mutate(consumo = consumo*0.4251428571, potencia = round(potencia*1.01387)) # convertendo medidas
# milhas por galao para km por litro e hp para cv

# padronizando os dados e criando data.frame
base_carros_padrao <- data.frame(
  "consumo"  = (base_carros$consumo - mean(base_carros$consumo, rm.na = TRUE))/
    sd(base_carros$consumo),
  "potencia" = (base_carros$potencia - mean(base_carros$potencia, rm.na = TRUE))/
    sd(base_carros$potencia))

# medidas de dispersão: Média
apply(base_carros, 2, mean)
apply(base_carros_padrao, 2, mean)

# medidas de dispersão: Desvio padrão
apply(base_carros, 2, sd)
apply(base_carros_padrao, 2, sd)

# medidas de dispersão: Mediana
apply(base_carros, 2, median)
apply(base_carros_padrao, 2, median)

# medidas de dispersão: Variância
apply(base_carros, 2, var)
apply(base_carros_padrao, 2, var)


# comparando os histogramas
hist(base_carros$consumo)
hist(base_carros_padrao$consumo)

# comparando os histogramas
hist(base_carros$potencia)
hist(base_carros_padrao$potencia)
