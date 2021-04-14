# chamando biblioteca tidyverse
library("tidyverse")

# base de dados sobre consumo dos veículos (base nativa do R - mtcars)
base_carros <- mtcars %>%
  select(consumo = mpg, potencia = hp) %>%
  mutate(consumo = consumo*0.4251428571, potencia = round(potencia*1.01387)) # convertendo medidas
# milhas por galao para km por litro e hp para cv

# mostre todos os carros que tem consumo acima de 9km/l e potencia acima de 90 cv
base_carros[base_carros$consumo > 9 & base_carros$potencia >90, ]

# construindo um intervalo entre 60 e 100 para potencia
base_carros[which(base_carros$potencia >= 60 & base_carros$potencia <= 100), ]

# todos os carros que começam com a letra M
base_carros[substring(row.names(base_carros), 1, 1) == "M", ]
