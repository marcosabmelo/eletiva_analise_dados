# -----------------------------------------------
# Amostragem
# -----------------------------------------------

# simulando distribuição normal com seed pontual
set.seed(412)
(dist_normal_sim <- rnorm(100)) # normal

# amostragem sem reposição usando função sample
sample(dist_normal_sim, 15, replace = FALSE) 

# amostragem com reposição usando função sample
sample(dist_normal_sim, 15, replace = TRUE)

# bootstrapping 05 replicações
(boots_normal_05 <- replicate(5, sample(dist_normal_sim, 15, replace = TRUE))) 


# calculando variância com bootstrapping (5; 50; 500 amostras de comprimento 15)
(var_boots_normal_05 <-replicate(5, var(sample(dist_normal_sim, 15, replace = TRUE))))
(var_boots_normal_50 <-replicate(50, var(sample(dist_normal_sim, 15, replace = TRUE))))
(var_boots_normal_500 <-replicate(500, var(sample(dist_normal_sim, 15, replace = TRUE))))


# comparando as variâncias
mean(var_boots_normal_05) # media das variâncias boostrapping 05
mean(var_boots_normal_50) # media das variâncias boostrapping 50
mean(var_boots_normal_500) # media das variâncias bootstrapping 500
var(dist_normal_sim) # variância dos dados originais


# ---------------------------------------
# biblioteca caret para Machine Learning
# ---------------------------------------

library(caret)
ls("package:caret")

# criando as partições de dados
(particao_dist_normal <- createDataPartition(1:length(dist_normal_sim), p=.7)) # 70%
(treino_dist_normal <- dist_normal_sim[unlist(particao_dist_normal)]) # partição de treino 
(teste_dist_normal <- dist_normal_sim[- unlist(particao_dist_normal)]) # partição de teste

# pode ser feito assim também?
(treino <- dist_normal_sim[1:70])
(teste  <- dist_normal_sim[71:100])