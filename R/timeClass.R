TimeClass <- R6Class("TimeClass",
                     public = list(
#' setBoundLimit
#' Define TID bounds
#' @param start the begining of TID "1000-01-01 00:00:00"
#' @param end the end of TID "3000-01-01 00:00:00"
#'
#' @return
#' @export
#'
#' @examples
                       setBoundLimit = function(start,end){
                         # TODO: must be in counstructor
                         # FIXME: how to deal with years like 1952 -3000 which results decimal values
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
                         private$p<-p
                         private$start=start
                         private$end=end
                       },
#' dateTimeToPOT
#' Convert date and time to TID scale.
#' @param datetime a date and time value in string format like '2016-01-02 00:00:00'. It must be
#' between "1000-01-01 00:00:00" and "3000-01-01 00:00:00"
#' @param scale the scale for TID. Must be one the following items
#' '1000y','500y','100y','50y','10y','1y','m','w','d','h','min','s'
#'
#' @return TID in an Integer format
#' @export
#'
#' @examples
                       dateTimeToPOT=function(scale,date){
                         pf<-private$p[which(private$p$res == scale),]
                         # TODO: Fix overwrite functions

                         if(nrow(pf)==0){
                           stop(paste("Scale is in wrong format. valid values are"),private$resolution)
                         }else{
                           myDate<-as.POSIXlt(date)
                           yearDiff=abs(private$start$year-myDate$year)
                           private$leapYears=private$getLeapYear(private$start$year,myDate$year)

                           switch (scale,
                                   '1y' = {

                                     diff<-yearDiff

                                   },
                                   'm'={
                                     yearOffset=yearDiff*12
                                     diff<-yearOffset+abs(private$start$mon-myDate$mon)
                                     # print(yearOffset)
                                   },
                                   'd'={
                                     dayOffset=yearDiff*365+private$leapYears

                                     diff<-dayOffset+abs(private$start$yday-myDate$yday)
                                     # print(diff)

                                   },
                                   'w'={
                                     dayOffset=yearDiff*365+private$leapYears

                                     diff<-round(dayOffset+abs(private$start$yday-myDate$yday)/7)
                                     # print(diff)
                                   }

                           )
                           result<- pf$start+diff
                           return(result)
                         }



                       },
                       getP=function(){
                         return(private$p)
                       },
                       getLeapYears=function(){
                         return(private$leapYears)
                       },

                       POTToDateTime=function(value){
                         pf<-private$p[which(private$p$start <value &&private$p$end ),]
                       }
                     ) ,
                     private = list(
                       resolution=c('1000y','500y','100y','50y','10y','1y','m','w','d','h','min','s'),
                       p=NA,
                       start=NA,
                       end=NA,
                       leapYears=NA,
                       getLeapYear=function(start,end){

                         return (private$leapYearsBefore(end) - private$leapYearsBefore(start + 1))

                       },
                       leapYearsBefore=function(year){

                         year--
                         return (round((year / 4) - (year / 100) + (year / 400)))
                       }
                     )
)


#' convert_datetime_to_tid
#' Convert date and time to TID scale.
#' @param datetime a date and time value in string format like '2016-01-02 00:00:00'. It must be
#' between "1000-01-01 00:00:00" and "3000-01-01 00:00:00"
#' @param scale the scale for TID. Must be one the following items
#' '1000y','500y','100y','50y','10y','1y','m','w','d','h','min','s'
#'
#' @return TID in an Integer format
#' @export
#'
#' @examples
#' convert_datetime_to_tid('1y','1980-01-01 00:00:00')
convert_datetime_to_tid <- function(datetime,scale){
   POT<-TimeClass$new()
   POT$setBoundLimit("1000-01-01 00:00:00","3000-01-01 00:00:00")
  # # only 1y m and d works
   result<-POT$dateTimeToPOT(datetime,scale)
   return(result)
}

#
# POT<-TimeClass$new()
# POT$setBoundLimit("1000-01-01 00:00:00","3000-01-01 00:00:00")
# # only 1y m and d works
# result<-POT$dateTimeToPOT('d','2016-01-02 00:00:00')
# p<-POT$getLeapYears()
# #
# p<-POT$getP()
#
# value<-268
# pf<-p[which((p$start <value | p$start ==value) & p$end>value ),]
#
# num<-value-pf$start
# startyear<-1000
# # we need to find scale from naming
# switch(pf$res,
#        '1y'={
#         return(startyear+num )
#        })
#
#
# # print(year)
# # print(p)
# # pf<-p[which(p$res == 'm'),]
# a<-as.POSIXlt("1000-01-01 00:00:00")
# startp=unclass(as.POSIXlt("1000-01-01 00:00:00"))
# endp=unclass(as.POSIXlt("3000-01-01 00:00:00"))
# startp=(as.POSIXlt("1000-01-01 00:00:00"))
# endp=(as.POSIXlt("3000-01-01 00:00:00"))
#
# # myDate=unclass(as.POSIXlt("1900-08-15 00:00:00"))
# #
# # yearDiff=abs(startp$year-myDate$year)
# # # for month
# # monthesOffset=yearDiff*12
# # # here we have months from 1000 to 1900 now we need to add month difference
# # diff=abs(startp$mon-myDate$mon)
# # result<-monthesOffset+diff
# # result<-pf$start+result
# # print(result)
# getLeapYear<-function(start,end){
#
#   # System.Diagnostics.Debug.Assert(start < end);
#   return (leapYearsBefore(end) - leapYearsBefore(start + 1))
#
# }
# leapYearsBefore<-function(year){
#   year--
#     return ((year / 4) - (year / 100) + (year / 400))
# }
# ceiling(getLeapYear(1582,1900))

