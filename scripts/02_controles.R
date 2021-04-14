# chamando biblioteca tidyverse ----
library("tidyverse")

# ampliando base de dados sobre veículos (base nativa do R - mtcars)
base_carros <- mtcars %>%
  select(consumo = mpg, cilindros = cyl, potencia = hp, peso = wt) %>%
  mutate(consumo = consumo*0.4251428571, potencia = round(potencia*1.01387)) # convertendo medidas
# milhas por galao para km por litro e hp para cv

# criando um loop simples para exibir motores V8 ----
for (i in 1:length(base_carros$cilindros)) {
  if (base_carros$cilindros[i] == 8) {print(c("Carro->", i, "é V8"))}
  else {print("Esse não é V8")}
    }

# melhorando a eficiencia com ifelse ----
ifelse(base_carros$cilindros == 8, print("Esse carro é V8"), print("Esse não"))


# usando lapply para exibir os carros com motor v8 ----
v8 <- which(base_carros$cilindros == 8)
lapply(1:sum(base_carros$cilindros == 8), function(i) row.names(base_carros)[v8[i]])