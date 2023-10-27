# Matriz de Confusão: matriz que relaciona as classes observadas (também chamadas de referência) e as classes preditas. Para melhor interpretação, oferece várias estatísticas auxiliares. Vamos ver as principais delas
  # Accuracy (Acc) = Acuidade, ou performance geral do modelo - total de acertos, sem considerar nenhuma penalidade ou ajuste
  # No Information Rate (NIR) = proporção da classe mais frequente - indica o quão a classe mais frequente está presente nos dados. É um valor de referência para compararmos com a acuidade, uma vez que o modelo poderia ganhar performance artificialmente aprendendo a sempre "chutar" na classe mais frequente. É oferecido também um teste de hipótese para verificar a hipótese de que a Acc é maior que o NIR. 
  # Kappa = coeficiente kappa de Cohen - em geral, mede a concordância de duas classificações. No caso de ML, tem a ver com a estimativa de acuidade controlada pela possibilidade de classificação aleatória. Assim, permite saber se o modelo é bom, mesmo considerando a chance de "sortear" o resultado. 

predicaoSAEB_RF_CLASS = predict(SAEB_RF_CLASS, testeSAEB) # criar predição
cmSAEB_RF_CLASS <- confusionMatrix(predicaoSAEB_RF_CLASS, testeSAEB$matematica)
cmSAEB_RF_CLASS
cmSAEB_RF_CLASS$table

  # Expected Accuracy (AccE) = Acuidade Esperada = estimativa de acuidade "esperada", ou seja, uma acuidade mínima que poderia ser conseguida simplesmente "chutando" a classe de forma aleatória. 

gtBaixa <- cmSAEB_RF_CLASS$table[1]+cmSAEB_RF_CLASS$table[2]
gtAlta <- cmSAEB_RF_CLASS$table[3]+cmSAEB_RF_CLASS$table[4]

pdBaixa <- cmSAEB_RF_CLASS$table[1]+cmSAEB_RF_CLASS$table[3]
pdAlta <- cmSAEB_RF_CLASS$table[2]+cmSAEB_RF_CLASS$table[4]

gtTotal <- gtAlta + gtBaixa

estAcc <- (gtBaixa*pdBaixa/gtTotal^2)+(gtAlta*pdAlta/gtTotal^2)
estAcc
