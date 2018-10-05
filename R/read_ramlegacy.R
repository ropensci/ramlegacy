# private function to check path is valid or not
check_path <- function(path) {
  if (!is_string(path)) {
    stop("`path` must be a string", call. = FALSE)
  }
  if (!file.exists(path)) {
    stop("`path` does not exist: ", sQuote(path), call. = FALSE)
  }
  TRUE
}


#' @importFrom readxl excel_sheets
#' @importFrom utils unzip
NULL

#' @title show_sheets
#' @description Unzips the excel database present at path and displays the sheets present in it
#' @param path Path to the zipped version of the excel database
#' @return A character vector containing the sheet names
#' @export
show_sheets <- function(path) {
  check_path(path)
  return(readxl::excel_sheets(unzip(path)))
}


#' @importFrom readxl read_excel
#' @importFrom utils unzip
NULL

#' @title read_ramlegacy
#' @description Reads different sheets of the excel database as tibbles
#'
#' @param path Path to the zipped version of the excel database
#' @param sheet Sheet to read. Either a string (the name of a sheet), or an
#'   integer (the position of the sheet). If not specified then defaults to the first
#'   sheet.
#' @param read_all If TRUE, then the function will read in all the dataframes from the database
#' @return A [tibble][tibble::tibble-package].If read_all is TRUE, then returns a list of tibbles from which user
#' can obtain individual tibbles
#' @export
#' @examples
#' # Specify sheet either by position or by name
#' read_ramlegacy("/data/version3.0", sheet =  2)
#' read_ramlegacy("/data/version3.0, sheet = "assessment")
#'
#' # Read in all the sheets as a list of tibbles
#' read_ramlegacy("/data/version3.0", read_all = TRUE)

read_ramlegacy <- function(path, sheet = NULL, read_all = FALSE) {
  check_path(path)
  file_unzip = unzip(path)
  na_vec <- c("NA", "NULL","_", "none", "N/A")
  if (read_all) {
    sheets = show_sheets(path)
    lst = vector("list", length(sheets))
    i = 1
    for (s in sheets) {
      lst[[i]] = readxl::read_excel(path = file_unzip, sheet = s, na = na_vec)
      i <- i+1
    }
    names(lst) <- sheets
    return(lst)
  } else {
    df = readxl::read_excel(path = file_unzip, sheet = sheet,
                            na = na_vec)
    return(df)
  }
}


