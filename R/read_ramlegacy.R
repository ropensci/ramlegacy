#' @importFrom readxl excel_sheets
NULL

#' @title show_ram_dfs
#' @description Displays the names of dataframes in excel database specified in path
#' @param path Path to the excel database
#' @return A character vector containing the dataframe names
#' @export
show_ram_dfs <- function(ram_path = NULL, version = NULL) {
  if (is.null(version)) {
    version <- 4.3
  } else {
    check_version(version)
  }
  if (is.null(ram_path)) {
    ram_path <- file.path(ram_dir(), paste0("v", version, ".zip"))
  } else {
    check_read_path(ram_path)
  }
  return(readxl::excel_sheets(ram_path))
}


#' @importFrom readxl read_excel
NULL

#' @title read_ramlegacy
#' @description Reads different sheets of the excel database as tibbles
#'
#' @param path Path to the the excel database
#' @param version Version of the database that will be read in. Defaults to most recent version (4.3)
#' @return A [tibble][tibble::tibble-package].If read_all is TRUE, then returns a list of tibbles from which user
#' can obtain individual tibbles
#' @export


read_ramlegacy <- function(ram_path = NULL, version = NULL) {
  if (is.null(version)) {
    version <- 4.3
  } else {
    check_version(version)
  }
  if (is.null(ram_path)) {
    ram_path <- file.path(ram_dir(vers = version),
                          sprintf("RLSADB v%.1f (assessment data only).xlsx", version))
  } else {
    check_read_path(ram_path)
  }
  na_vec <- c("NA", "NULL","_", "none", "N/A")
  sheets = readxl::excel_sheets(ram_path)
  lst = vector("list", length(sheets))
  i = 1
  # read in all the dataframes
  for (s in sheets) {
    lst[[i]] = readxl::read_excel(path = ram_path, sheet = s, na = na_vec)
    i <- i+1
  }
  names(lst) <- sheets

  # write all dataframes as rdata objects
  db_path = file.path(ram_dir(vers = version), paste0("v", as.character(version), ".RData"))
  save(lst, file = db_path)
  # load the dataframes
  load(db_path)
}


