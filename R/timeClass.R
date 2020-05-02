library(R6)
TimeClass <- R6Class("TimeClass",
                     public = list(
                       setBoundLimit = function(start,end)

                       {
                         # TODO: must be in counstructor
                         startp=as.POSIXlt(start)
                         endp=as.POSIXlt(end)

                         start=unclass(as.POSIXlt(start))
                         end=unclass(as.POSIXlt(end))
                         p=data.frame(res=private$resolution, start=rep(0,length(private$resolution)),end=rep(0,length(private$resolution)))



                         p[1,]$start=1
                         p[1,]$end=(end$year-start$year)/1000

                         p[2,]$start=1+p[1,]$end
                         p[2,]$end=(end$year-start$year)/500+p[1,]$end

                         p[3,]$start=1+p[2,]$end
                         p[3,]$end=(end$year-start$year)/100+p[2,]$end

                         p[4,]$start=1+p[3,]$end
                         p[4,]$end=(end$year-start$year)/50+p[3,]$end

                         p[5,]$start=1+p[4,]$end
                         p[5,]$end=(end$year-start$year)/10+p[4,]$end

                         p[6,]$start=1+p[5,]$end
                         p[6,]$end=(end$year-start$year)+p[5,]$end

                         p[7,]$start=1+p[6,]$end
                         p[7,]$end=(end$year-start$year)*12+p[6,]$end

                         #################################
                         p[8,]$start=1+p[7,]$end
                         p[8,]$end=as.numeric(difftime(endp,startp,units="week"))+p[7,]$end
                         ########################################
                         p[9,]$start=1+p[8,]$end
                         p[9,]$end=as.numeric(endp-startp)+p[8,]$end

                         p[10,]$start=1+p[9,]$end
                         p[10,]$end=as.numeric(endp-startp)*24+p[9,]$end

                         p[11,]$start=1+p[10,]$end
                         p[11,]$end=as.numeric(endp-startp)*24*60+p[10,]$end

                         p[12,]$start=1+p[11,]$end
                         p[12,]$end=as.numeric(endp-startp)*24*60*60+p[11,]$end
                         print(p)
                         private$p<-p
                         private$start=start
                         private$end=end
                       },
                       dateTimeToPOT=function(scale,year=NA,day=NA,month=NA){

                         # TODO: Fix overwrite functions
                         pf<-p[which(p$res == scale),]
                         if(nrow(pf)==0){
                           stop(paste("Scale is in wrong format. valid values are"),private$resolution)
                         }else{
                           switch (scale,
                                   '1y' = {
                                     mydate<-as.POSIXlt(paste(year,"-01-01 00:00:00",sep = ""))
                                     diff=abs(private$start$year-mydate$year)
                                     return(pf$start+diff)
                                   }

                           )
                         }



                       }
                     ) ,
                     private = list(
                       resolution=c('1000y','500y','100y','50y','10y','1y','m','w','d','h','m','s'),
                       p=NA,
                       start=NA,
                       end=NA
                     )
)


data_to_tid <- function(scale,time){

  POT<-TimeClass$new()
  POT$setBoundLimit("1000-01-01 00:00:00","3000-01-01 00:00:00")


  result<-POT$dateTimeToPOT(scale,time)
  return(result)
}



