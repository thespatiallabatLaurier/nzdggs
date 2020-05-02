source('F:\\Majid\\R-shiny\\dggshiny\\dggshiny\\timeClass.R')
source('F:\\Majid\\R-shiny\\dggshiny\\dggshiny\\dataImporterClass.R')
library(RODBC)
path = "F:\\Majid\\Modis\\mk\\Net_ET_8Day_500m_v6\\ET_500m\\2008-10\\rep"
setwd(path)
file.names <- dir(path, pattern = "*.csv")
directory <- path
length <-length(file.names)
count = 0
POT<-TimeClass$new()
POT$setBoundLimit("1000-01-01 00:00:00","3000-01-01 00:00:00")


importer <- ImporterClass$new()
importer$setDSN('NZSQL_M')

#firstRun <- TRUE

for (f in file.names) {
  count = count +1
  print(unlist(strsplit(basename(f), "_"))[3])


  # # only 1y m and d works
  result<-POT$dateTimeToPOT('w',paste(unlist(strsplit(basename(f), "_"))[3], '00:00:00'))
  
  importer$setTableDetails('tbl_modis',finaltablecolumns=list(name=c('dggid','value','tid'),type=c('bigint','float','bigint')),
                           inputfilecolumns=list(name=c('value','dggid'),type=c('varchar(100)','varchar(100)')),insertcolumns=paste('CAST(dggid AS bigint),CAST(value AS float ),',result),createTable = firstRun)
  
  if (firstRun){
    firstRun <- FALSE
  }
  
  importer$importFile(  paste(dirname(file.path(paste(path,basename(f),sep = "/"))),basename(f),sep = "/"))
  
  
  string =paste("INSERT INTO SPATIAL_DB.SPATIAL_SCHEMA.METADATA (NAME , U_ID , DISCRIPTION, MIN_VALUE, MAX_VALUE, MIN_ZOOM, MAX_ZOOM, RESOLUTION , TID, STARTDATE, DURATION , TYPE, SCALE) VALUES ('Modis 8 Days','tbl_modis','Modis 8 Days ET",unlist(strsplit(basename(f), "_"))[3],"',0,100,0,20,22,",result,",'",unlist(strsplit(basename(f), "_"))[3],"',8,1,'w');")
  # "QUOTEDVALUE 'DOUBLE'  "
  
  # print(dggcsv_path,filename)
  sqlQuery(odbcConnect('NZSQL_M'), string, errors = TRUE)
  
}

  
    

