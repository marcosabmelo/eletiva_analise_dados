# criando matriz 100x2 para teste de correlação
matriz <- matrix(rnorm(200, mean = 0, sd = 1), nrow = 100, ncol = 2)

# correlação entre os vetores da matriz
correlacao <- cor(matriz)

# estrutura da correlaçao
str(correlacao)

# plotando os dados da matriz
pairs(matriz)
