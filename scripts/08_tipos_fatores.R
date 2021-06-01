# ---------------------------------------------------------------------------------
# criando ums estrutura de fatores
# ---------------------------------------------------------------------------------
# Vetor de países corruptos
(paises <- sample(1:4, 40, replace = T))
ID_paises <- c(Eritreia = 1, Brasil = 2, Nicarágua = 3, Camboja = 4)

(paises <- factor(paises,
                  levels = ID_paises,
                  labels = names(ID_paises)))

# ---------------------------------------------------------------------------------
# Colocando o Brasil em seu devido lugar
(paises <- relevel(paises,
                   ref = "Brasil"))

# ---------------------------------------------------------------------------------
# Criando volume de desvios em Bilhões de US$
(desvios <- sample(100:500, 40, replace = T))
(paises <- reorder(paises, desvios))

# ---------------------------------------------------------------------------------
# Retirando os scores da variável fator
attr(paises, "scores") <- NULL
paises