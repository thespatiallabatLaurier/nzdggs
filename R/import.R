
#' import_to_db
#'
#' @param directory Directory of CSV files
#' @param table_name  Name of the table to import data into
#' @param append add data to an existing table, if it is False we will make a new table
#' @param drop drops table while creating a new table, Default is False
#' @keywords netezza, import
#' @return
#' @export
#'
#' @examples
#' import_to_db()
import_to_db <- function(directory,table_name,append=T,drop=F){
  if(love==TRUE){
    print("I love cats!")
  }
  else {
    print("I am not a cool person.")
  }
}
