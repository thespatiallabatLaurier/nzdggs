# Convert and Importing Data

Converting a csv file of lat,lon points to DGGS data model
```r
r <- read.csv('D:/Bathurst_caribou_collars.csv')
nz_convert_points_df_to_dggs(r$Latitude,r$Latitude,10,20,r,"C:/result")
```

# Lat/Lon To DGGS
Converting and importing a csv to the netezza

```r
#Assume we have a csv file with following columns. X,DGGID,EVENT (two keys)
csv<-read.csv2("mpb-ev.csv",sep=",")
head(csv)
  X       DGGID EVENT
1 1 14772025795 CONTR
2 2 14772084845 CONTR
3 3 14772084846 CONTR
4 4 14772143895 CONTR
5 5 14772143896 CONTR
6 6 14772143897 CONTR
#Make a dataframe with following columns. The order of columns are important
df <- data.frame(VALUE=csv$EVENT,DGGID=csv$DGGID,TID=rep(-1,length(csv$DGGID)),KEY=rep("EVENT",length(csv$DGGID)))

#save the dataframe as a csv with row.names=F and seperator ="," . Use write.csv instead of write.csv2
write.csv(df,row.names = F, "import//event.csv",sep=",")

#another dataframe for the second key
df2 <- data.frame(VALUE=csv$X,DGGID=csv$DGGID,TID=rep(-1,length(csv$DGGID)),KEY=rep("ID",length(csv$DGGID)))
#save in the same folder with diffrent name
write.csv(df2,row.names = F,"import//id.csv",sep=",")
#init DSN object for data import. Define SCHEMA based on your user
DSN <- nz_init("NZSQL","SCHEMA")
#impord data from folder to the database. The key type is varchar(100) for multiple keys.
nz_import_dir_to_db(DSN,"/home/[user]/import/","mbpev","varchar(100)")

```