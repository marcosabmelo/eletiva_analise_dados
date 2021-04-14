# criando uma função para padronizar uma variável
padronizar = function(a) {
  if (is.numeric(a) == FALSE) {
    print("Variável não é numérica")
  } else {
    a <- (a-mean(a))/sd(a)
    return(a)
  }
}
  
# iniciando janela (1,2)
par(mfrow = c(1, 2))

# setando uma semente
set.seed(625)

# base normal e padronizada
dist_normal <- rnorm(100, 10, 3)
dist_normal_padrao <- padronizar(dist_normal)

# plotando os histogramas
hist(dist_normal)
hist(dist_normal_padrao)