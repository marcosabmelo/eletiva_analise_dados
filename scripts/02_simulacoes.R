# seed(123) rodando em background
(task_seed <- addTaskCallback(function(...) {set.seed(123);TRUE}))

# simulando distribuições 
(dist_normal_sim <- rnorm(100)) # normal
(dist_binomial_sim <- rbinom(100, 1, 0.7)) # binomial
(dist_poisson_sim <- rpois(100, lambda = 3)) # poisson
(dist_exponencial_sim <- rexp(100, rate = 3)) # exponencial

# dividindo os números da distribuição normal em positivos e negativos
(pos <- sum(dist_normal_sim > 0))
(neg <- sum(dist_normal_sim < 0))

# repetições: como fixamos a semente, a impressão será sempre a mesma
if (pos > neg) {
  rep("Tem mais números positivos", pos)
  } else {
    rep("Tem mais números negativos", neg)
  } 

# sequências: criando um índice começando da quantidade de positivos
(indice_simulacao <- seq(pos, length(dist_normal_sim)))

# encerrando seed(123) em background
removeTaskCallback(task_seed)

# mesmo depois de encerrado o processo, a seed continua setada. Os mesmo números aleatórios
# continuam se repetindo. Se isso acontecer com você Vá em Session | Restart R