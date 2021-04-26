# ---------------------------------------------------------------------------------------
#### Staging area e uso de memória

# ficamos com staging area??

ls() # lista todos os objetos no R
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# vamos ver quanto cada objeto está ocupando

for (itm in ls()) { 
  print(formatC(c(itm, object.size(get(itm))/1024), # Exibindo em KB
                format="d", 
                width=30), 
        quote=F)
}

  # >> As bases de 2018 a 2021 não são pesados. A base unida é a mais pesada. Deve ter sido
  # >> pela mudança das variáveis para FATOR.

ls() # lista todos os objetos no R
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# agora, vamos remover

gc() # uso explícito do garbage collector

rm(list = c('sinistrosRecife2020Raw', 'sinistrosRecife2021Raw'))

# deletando todos os elementos: rm(list = ls())
# deletando todos os elementos, menos sinistrosRecifeRaw e a função naZero

rm(list=(ls()[ls() != "sinistrosRecifeRaw" & ls() != "naZero"]))
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# Salvando os dados
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")
# ---------------------------------------------------------------------------------------