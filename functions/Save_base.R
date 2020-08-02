

library(readxl)
library(RSQLite)

setwd("D:/Blog/Estudo FIAs")

temp = list.files(path="D:/Blog/Estudo FIAs/Retorno Fundos",pattern="*.csv")

data<-gsub("[__A-Za-z/.]","",temp)

for (temporario in temp){
  dados<-read.csv2(paste0("D:/Blog/Estudo FIAs/Retorno Fundos/",temporario),stringsAsFactors = F)
                   #colClasses = c("character","date",rep("numeric",6)))
  
  # dados$VL_TOTAL<-as.numeric(dados$VL_TOTAL)
  # dados$VL_QUOTA<-as.numeric(dados$VL_QUOTA)
  # dados$VL_PATRIM_LIQ<-as.numeric(dados$VL_PATRIM_LIQ)
  
  nomes.change<-c("VL_TOTAL","VL_QUOTA", "VL_PATRIM_LIQ", "CAPTC_DIA", "RESG_DIA", "NR_COTST")
  
  for (nomes in nomes.change){
    dados[,nomes]<-as.numeric(dados[,nomes])
    
  }
  
  #alguns dataframes vem com o indice no inicio, junto com o CNPJ, alterar nestes casos para pegar
  #so o CNPJ
  if(names(dados)[1]=="X.CNPJ_FUNDO"){
    #altera CNPj para remover tudo antes da vírgula
    dados[,1]<-gsub("(.*),","",dados$X.CNPJ_FUNDO)
    #altera nome da base
    names(dados)<-c("CNPJ_FUNDO","DT_COMPTC", "VL_TOTAL", "VL_QUOTA", "VL_PATRIM_LIQ", "CAPTC_DIA", "RESG_DIA", "NR_COTST")
  }
  
  #merge com cadastro
  dados<-merge(dados, cadastro[,c(1,2,11)], by="CNPJ_FUNDO")
  
  nomes.dados<-c("CNPJ_FUNDO","DENOM_SOCIAL","CLASSE","DT_COMPTC","VL_TOTAL","VL_QUOTA","VL_PATRIM_LIQ",
                 "CAPTC_DIA","RESG_DIA","NR_COTST")
  #ajustar colunas
  dados<-dados[,nomes.dados]
  
  source("D:/Blog/Estudo FIAs/functions/Get_base.R")
  
  Exporta_Db(dados)
  
  print(paste0("file ", temporario, " imported successfully to database"))
  
  rm(dados)
  gc()
}

#Conectar ao BD
conn = dbConnect(dbDriver("SQLite"),"base_fundos.sqlite")
#Overwrite table cadastro com tabela mais atualizada
dbWriteTable(conn = conn,"cadastro_fundos", cadastro,overwrite = TRUE)
#Disconectar do BD
dbDisconnect(conn)

# sql<-"SELECT inf_diario_fi.CNPJ_FUNDO,
# inf_diario_fi.DT_COMPTC,
# inf_diario_fi.VL_TOTAL,
# inf_diario_fi.VL_QUOTA,
# inf_diario_fi.VL_PATRIM_LIQ,
# inf_diario_fi.CAPTC_DIA,
# inf_diario_fi.RESG_DIA,
# inf_diario_fi.NR_COTST,
# cadastro_fundos.DENOM_SOCIAL,
# cadastro_fundos.CLASSE 
# into dataset_fundos FROM inf_diario_fi LEFT JOIN cadastro_fundos ON inf_diario_fi.CNPJ_FUNDO = cadastro_fundos.CNPJ_FUNDO"

#dados<-read.csv2(paste0("D:/Blog/Estudo FIAs/Retorno Fundos/",temp[1]),stringsAsFactors = F)
#summary(dados)


#head(dados[is.na(dados$X.CNPJ_FUNDO),])


#teste<-gsub("*,","",dados$X.CNPJ_FUNDO)
