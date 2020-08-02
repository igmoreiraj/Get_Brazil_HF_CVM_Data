
rm(list = ls())

library(readxl)
library(RSQLite)
library(readr)

setwd("D:/Blog/Estudo FIAs")

#source files
#remove old data
source("functions/Remove_old_data.R")
#pega cadastro
source("functions/Get_cadastro.R")
#Exporta dataframe para a base de dados
source("D:/Blog/Estudo FIAs/functions/Get_base.R")

#gera data do update
data= Sys.Date()-2

#Remove os dados antigos do mês
remove_old_data(data)

#update cadastro file
cadastro<-pega_cadastro(data)

#################### Rotina que adiciona os dados do mês atual #########################

#cria url com endereco para pegar os dados
address<-paste0("http://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_",format(data,"%Y%m"),".csv")
#pega dados historico cotas
dados<-read.csv2(address,stringsAsFactors = F)



#alguns dataframes vem com o indice no inicio, junto com o CNPJ, alterar nestes casos para pegar
#so o CNPJ
if(names(dados)[1]=="X.CNPJ_FUNDO"){
  #altera CNPj para remover tudo antes da vírgula
  dados[,1]<-gsub("(.*),","",dados$X.CNPJ_FUNDO)
  #altera nome da base
  names(dados)<-c("CNPJ_FUNDO","DT_COMPTC", "VL_TOTAL", "VL_QUOTA", "VL_PATRIM_LIQ", "CAPTC_DIA", "RESG_DIA", "NR_COTST")
}

nomes.change<-c("VL_TOTAL","VL_QUOTA", "VL_PATRIM_LIQ", "CAPTC_DIA", "RESG_DIA", "NR_COTST")

for (nomes in nomes.change){
  dados[,nomes]<-as.numeric(dados[,nomes])
  
}

#run pega_cadastro
#cadastro<-pega_cadastro(Sys.Date()-1)

#merge com cadastro
dados<-merge(dados, cadastro[,c(1,2,11)], by="CNPJ_FUNDO")

nomes.dados<-c("CNPJ_FUNDO","DENOM_SOCIAL","CLASSE","DT_COMPTC","VL_TOTAL","VL_QUOTA","VL_PATRIM_LIQ",
               "CAPTC_DIA","RESG_DIA","NR_COTST")
#ajustar colunas
dados<-dados[,nomes.dados]

#exporta base para o DB
Exporta_Db(dados)


