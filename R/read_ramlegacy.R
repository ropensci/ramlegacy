#' @importFrom readxl read_excel
NULL

#' @title read_ramlegacy
#' @noRd

read_ramlegacy <- function(path = NULL, version = NULL) {
  excel_file_name <- grep("RLSADB.*", list.files(path), value = T)
  excel_path <- file.path(path, excel_file_name)
  na_vec <- c("NA", "NULL","_", "none", "N/A", "")
  sheets = readxl::excel_sheets(excel_path)
  lst = vector("list", length(sheets))
  i = 1
  # read in all the dataframes

  for (s in sheets) {
    # specify column types for problematic sheets
    if (s == "Timeseries") {
      col_type_vec <- c(rep("text", 5), rep("numeric", 1))
    } else if (s == "Timeseries_values_view") {
      col_type_vec <- c(rep("text", 4), rep("numeric", 8))
    } else if (s == "bioparams") {
      col_type_vec <- c(rep("text", 7))
    } else {
      col_type_vec = NULL
    }
      lst[[i]] = readxl::read_excel(path = excel_path, sheet = s, na = na_vec, col_types = col_type_vec)
      i <- i+1
    }

  names(lst) <- sheets
  # write the list of all dataframes as rdata object
  write_path <- file.path(path, paste0("v", version, ".rds"))
  saveRDS(lst, file = write_path)
  on.exit(file.remove(excel_path), add = T)
}


