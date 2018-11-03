#' @importFrom readxl read_excel
NULL

#' @title read_ramlegacy
#' @noRd

read_ramlegacy <- function(vers_path = NULL, version = NULL) {
  excel_file_name <- grep("RLSADB.*\\.(xlsx|xls)", list.files(vers_path), value = T)
  excel_file_path <- file.path(vers_path, excel_file_name)
  na_vec <- c("NA", "NULL","_", "none", "N/A", "")
  sheets = readxl::excel_sheets(excel_file_path)
  lst_dfs = vector("list", length(sheets))
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
      lst_dfs[[i]] = readxl::read_excel(path = excel_file_path, sheet = s, na = na_vec, col_types = col_type_vec)
      i <- i+1
    }

  names(lst_dfs) <- sheets
  # write the list of all dataframes as rdata object
  write_path <- file.path(vers_path, paste0("v", version, ".rds"))
  saveRDS(lst_dfs, file = write_path)
  filesToRemove <- grep(list.files(vers_path), pattern='v[0-9]\\.[0-9]+\\.rds', inv=T, value=T)
  on.exit(unlink(file.path(vers_path, filesToRemove), recursive = T, force = T), add = T)
}


