

pega_cadastro<-function(data){
  #input error checking
  stopifnot(is(data,"Date"),length(data)==1)
  
  #concatena url da base desejada
  url<-paste0("http://dados.cvm.gov.br/dados/FI/CAD/DADOS/inf_cadastral_fi_", format(data,"%Y%m%d"),".csv")
  
  #le csv com url
  cadastro <- read_delim(url,";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),trim_ws = TRUE)

  #Conectar ao BD
  conn = dbConnect(dbDriver("SQLite"),"base_fundos.sqlite")
  #Overwrite table cadastro com tabela mais atualizada
  dbWriteTable(conn = conn,"cadastro_fundos", cadastro,overwrite = TRUE)
  #Disconectar do BD
  dbDisconnect(conn)
  
  print("Base atualizada com sucesso")
  
  return(cadastro)
}

#as.Date(Sys.Date())-as.Date("2005-01-01")
convertToUTF16 <- function(s){
  lapply(s, function(x) unlist(iconv(x,from="UTF-8",to="UTF-16LE",toRaw=TRUE)))
}

############## Código que compara nomes dos cadastros dos fundos ##############

#pega_cadastro(as.Date("2020-05-22"))
#test if A is subset of B
#setequal(intersect(teste1,teste),teste1)
#all(teste1 %in% teste)
#teste2<-setdiff(teste1,teste)
#teste3<-cadastro2[cadastro2$CNPJ_FUNDO %in% teste2,]
#

#cadastro<-read.csv2("Nomes fundos/inf_cadastral_fi_20200522.csv", stringsAsFactors = F)



