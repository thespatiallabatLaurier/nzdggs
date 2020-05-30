TimeClass <- R6Class("TimeClass",
                     public = list(

#' @param start the begining of TID strptime( '01-01-1000 00:00:00', "%d-%m-%Y %H:%M:%S")
#'
#' @param end the end of TID strptime( '01-01-3000 00:00:00', "%d-%m-%Y %H:%M:%S")
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

                         p=data.frame(res=private$resolution, start=rep(0,length(private$resolution)),end=rep(0,length(private$resolution)))


                         startu=unclass(as.POSIXlt(start))
                         endu=unclass(as.POSIXlt(end))

                         p[1,]$start=1
                         p[1,]$end=(endu$year-startu$year)/1000

                         p[2,]$start=1+p[1,]$end
                         p[2,]$end=(endu$year-startu$year)/500+p[1,]$end

                         p[3,]$start=1+p[2,]$end
                         p[3,]$end=(endu$year-startu$year)/100+p[2,]$end

                         p[4,]$start=1+p[3,]$end
                         p[4,]$end=(endu$year-startu$year)/50+p[3,]$end

                         p[5,]$start=1+p[4,]$end
                         p[5,]$end=(endu$year-startu$year)/10+p[4,]$end

                         p[6,]$start=1+p[5,]$end
                         p[6,]$end=(endu$year-startu$year)+p[5,]$end

                         p[7,]$start=1+p[6,]$end
                         p[7,]$end=(endu$year-startu$year)*12+p[6,]$end

                         #################################
                         p[8,]$start=1+p[7,]$end
                         p[8,]$end=as.numeric(difftime(endp,startp,units="week"))+p[7,]$end
                         ########################################
                         p[9,]$start=1+p[8,]$end
                         p[9,]$end=as.numeric(difftime(endp,startp,units="days"))+p[8,]$end


                         p[10,]$start=1+p[9,]$end
                         p[10,]$end=(as.numeric(difftime(endp,startp,units="days"))*2)+p[9,]$end

                         p[11,]$start=1+p[10,]$end
                         p[11,]$end=(as.numeric(difftime(endp,startp,units="days"))*4)+p[10,]$end

                         p[12,]$start=1+p[11,]$end
                         p[12,]$end=(as.numeric(difftime(endp,startp,units="days"))*8)+p[11,]$end

                         p[13,]$start=1+p[12,]$end
                         p[13,]$end=(as.numeric(difftime(endp,startp,units="hours")))+p[12,]$end

                         p[14,]$start=1+p[13,]$end
                         p[14,]$end=(as.numeric(difftime(endp,startp,units="mins")))+p[13,]$end

                         p[15,]$start=1+p[14,]$end
                         p[15,]$end=(as.numeric(difftime(endp,startp,units="secs")))+p[14,]$end

                         private$p<-p
                         private$start=startp
                         private$end=endp
                       },
#' @param datetime a date and time value in string format like '2016-01-02 00:00:00'. It must be
#' between "1000-01-01 00:00:00" and "3000-01-01 00:00:00"
#' @param scale the scale for TID. Must be one the following items
#' '1000y','500y','100y','50y','10y','1y','m','w','d','h','min','s'
#'
#' @return TID in an Integer format
#' @export
#'
#' @examples
                       dateTimeToPOT=function(date,scale){
                         pf<-private$p[which(private$p$res == scale),]

                         # TODO: Fix overwrite functions

                         if(nrow(pf)==0){
                           stop(paste("Scale is in wrong format. valid values are"),private$resolution)
                         }else{

                           myDate <- as.POSIXlt(date)
                           #print(myDate)
                           #startu=unclass(private$start)
                           #endu=unclass(myDate)
                           mDiff = private$getElapsedMonths(myDate,private$start)
                           #private$leapYears=private$getLeapYear(private$start$year,myDate$year)

                           switch (scale,
                                   'min'={
                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="mins"))*1)
                                   },
                                   's'={
                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="secs"))*1)
                                   },
                                   'h'={
                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="hours"))*1)
                                   },
                                   '3h'={
                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="days"))*8)
                                   },
                                   '6h'={
                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="days"))*4)
                                   },
                                   '12h'={
                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="days"))*2)
                                   },
                                   'd'={

                                      diff <- floor(as.numeric(difftime(myDate,private$start,units="days"))*1)

                                      },
                                   'w'={
                                      diff <- floor(as.numeric(difftime(private$start,myDate,units="week")))
                                   },
                                   'm'={
                                     diff <- mDiff
                                   },
                                   '1y'={
                                      diff <- floor(mDiff/(12*1))
                                   },
                                   '10y'={
                                      diff <- (floor(mDiff/(12*10)))
                                   },
                                   '50y'={
                                      diff <- (floor(mDiff/(12*50)))
                                   },
                                   '100y'={
                                      diff <- (floor(mDiff/(12*100)))
                                   },
                                   '500y'={
                                      diff <- (floor(mDiff/(12*500)))
                                   },
                                   '1000y'={
                                      diff <- (floor(mDiff/(12*1000)))
                                   }

                           )
                           result<- pf$start + diff
                           return(as.integer(result))
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
                       resolution=c('1000y','500y','100y','50y','10y','1y','m','w','d','12h','6h','3h','h','min','s'),
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
                       },
                       getElapsedMonths =  function(ed, sd) {
                          #ed <- as.POSIXlt(end_date)
                          #sd <- as.POSIXlt(start_date)
                          12 * (ed$year - sd$year) + (ed$mon - sd$mon)
                       }
                     )
)

#' Convert Datetime To Tid
#' @description Converts a data and time object to tid. Use this function to make a datatime object ``strptime( '02-01-1980 00:00:00', "%d-%m-%Y %H:%M:%S")``
#' @param datetime a date and time value in string format like '2016-01-02 00:00:00'. It must be
#' between "1000-01-01 00:00:00" and "3000-01-01 00:00:00"
#' @param scale the scale for TID. Must be one the following items
#' '1000y','500y','100y','50y','10y','1y','m','w','d','12h','6h','3h','h','min','s'
#'
#' @return TID in an Integer format
#' @export
#'
#' @examples
#' \dontrun{
#' convert_datetime_to_tid(strptime( '02-01-1980 00:00:00', "%d-%m-%Y %H:%M:%S"),'1y')
#' #Another Example
#' start <- as.Date("01-01-1980",format="%d-%m-%Y")
#' end   <- as.Date("01-01-2020",format="%d-%m-%Y")
#'
#' theDate <- start
#' df <- data.frame()
#' names(df) <- c("time","tid")
#' while (theDate <= end)
#' {
#'    t <- strptime(paste(format(theDate,"%d-%m-%Y")," 00:00:00"), "%d-%m-%Y %H:%M:%S")
#'    tid <- convert_datetime_to_tid(t, "d")
#'    print(tid)
#'    df <- rbind(df, data.frame(time = t, tid = tid))
#'    theDate <- seq.Date( theDate, length=2, by='1 years' )[2]
#' }
#'}
nz_convert_datetime_to_tid <- function(datetime,scale){
   POT<-TimeClass$new()
   POT$setBoundLimit(strptime( '01-01-1000 00:00:00', "%d-%m-%Y %H:%M:%S"),strptime( '01-01-3000 00:00:00', "%d-%m-%Y %H:%M:%S"))
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

