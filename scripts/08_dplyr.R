# ---------------------------------------------------------------------------------
# Sumário e Agrupamento
# ---------------------------------------------------------------------------------
# Usando a base de corrupção
# Contando os casos por situação na justiça
count(base_corrupcao, justica)

# Agrupando por ideologia, qual delas rouba mais
base_corrupcao %>% group_by(ideologia) %>% summarise(Total = sum(desvios))

# Agrupando por ideologia, em Média quem rouba mais: Cargo Eletivo ou Não
base_corrupcao %>% group_by(ideologia, cargo) %>% summarise(Média = mean(desvios))

# ---------------------------------------------------------------------------------
# Manipulação de casos
# ---------------------------------------------------------------------------------
# Bandidos brasileiros da esfera federal, roubam quanto em média? 
base_corrupcao %>% filter(paises == "Brasil" & esfera == "Federal") %>%
  summarise(Média = mean(desvios))

# Bandidos dos outros países, não feredais, roubam quanto no total? 
base_corrupcao %>% filter(paises != "Brasil" & esfera != "Federal") %>%
  group_by (paises, esfera) %>% 
  summarise(Total = sum(desvios))

# Dentre todos os inocentados na justiça da Nicarágua, mostre por ordem crescente de idade
base_corrupcao %>% filter(justica == "Inocentado" & paises == "Nicarágua") %>% arrange(idade)

# Dentre todos os que têm salário entre 35000 e 37000 da Eritreia, mostre por ordem decrescente de processos
base_corrupcao %>% filter(salario > 35000 & salario < 37000 & paises == "Eritreia") %>% arrange(desc(processos))

# ---------------------------------------------------------------------------------
# Manipulação de colunas
# ---------------------------------------------------------------------------------
# Mostre a quantidade total de inocentes por ordem decrescente de processos
base_corrupcao %>% select(paises, justica, desvios, processos) %>% filter(justica == "Inocentado") %>% 
  arrange(desc(processos))

# Dentre todos os prescritos qual a taxa de desvios por idade?
base_corrupcao %>% select(paises, justica, desvios, processos, idade) %>%
  mutate(Taxa_Desvios_Idade = desvios/idade) %>% 
  filter(justica == "Prescrito") %>% 
  rename(tdi = Taxa_Desvios_Idade) %>%
  arrange(desc(tdi))