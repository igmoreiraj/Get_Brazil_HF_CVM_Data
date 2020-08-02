
Exporta_Db<-function(df){

  #Conectar ao BD
  conn = dbConnect(dbDriver("SQLite"),"base_fundos.sqlite")
  
  #Consultar registro
  #df<- dbGetQuery(conn,"SELECT * FROM estoque WHERE data = '2018-12-07' and papel='LTN';")
  
  
  #Inserir Registro
  #rows = dbExecute(conn,"INSERT INTO estoque (preco,quantidade,vencimento,papel,data) 
  #                 VALUES (3200.54,670,'2040-01-01','NTN-B','2018-06-15')")
  #rows
    
  #as datas foram formatadas como inteiras para o banco,
  #entao vamos formatar como string antes de enviar
  #df$DT_COMPTC<- format(df$DT_COMPTC,"%Y-%m-%d")
  
  #delete rows with wrong dates
  #dbExecute(conn,"DELETE FROM estoque WHERE data='17872'") #apagando registros
  
  #dados$papel[4]<-NA
  
  dbBegin(conn)
  
  #Insert de DE-PARA
  sql=paste0(
    "INSERT into dataset_fundos",
    "  (CNPJ_FUNDO,DENOM_SOCIAL,CLASSE,DT_COMPTC,VL_TOTAL,VL_QUOTA,VL_PATRIM_LIQ,CAPTC_DIA,RESG_DIA,NR_COTST)", #colunas no banco de dados (PARA)
    "VALUES ",
    "  (:CNPJ_FUNDO,:DENOM_SOCIAL,:CLASSE,:DT_COMPTC,:VL_TOTAL,:VL_QUOTA,:VL_PATRIM_LIQ,:CAPTC_DIA,:RESG_DIA,:NR_COTST)" #colunas no dataframe (DE)
  )
  
  
  r=try(dbSendQuery(conn,sql,params=dados))
  
  if(is(r,"try-error")){
    print("ocorreu um erro. Executando rollback...")
    cat(r)
    dbRollback(conn)
  }else {
    dbCommit(conn)
    print("dados inseridos com sucesso")
    
  }
  
  
  dbDisconnect(conn)
}
