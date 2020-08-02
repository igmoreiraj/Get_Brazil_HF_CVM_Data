remove_old_data<-function(current.date){
  
  #get sequence of current dates
  start.date<-as.Date(cut(current.date,"month"))
  vetor.datas<-seq.Date(from = start.date, to= current.date, by="1 day")
  
  #converte datas para string para inserir na query
  datas.vector.string = toString(sprintf("'%s'", vetor.datas))
  #cria query do sql com (%s) de  id para ser substituído depois pelas datas
  sql_fmt<-"DELETE from dataset_fundos where DT_COMPTC in (%s)"
  #aplica a substituição do id pelo vetor de datas em forma de string
  sql<-sprintf(sql_fmt,datas.vector.string)
  
  #Conectar ao BD
  conn = dbConnect(dbDriver("SQLite"),"base_fundos.sqlite")
  #Send SQL Query
  log.remove<-dbExecute(conn,sql)
  #Disconectar do BD
  dbDisconnect(conn)
  
  return(log.remove)
}


#Confere se todas as datas estão dentro do vetor datas
#setequal(intersect(unique(dados.new$DT_COMPTC),as.character(vetor.datas)),unique(dados.new$DT_COMPTC))

