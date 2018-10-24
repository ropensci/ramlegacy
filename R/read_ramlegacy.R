#' @importFrom readxl read_excel
NULL

#' @title read_ramlegacy
#' @noRd

read_ramlegacy <- function(ram_path = NULL, version = NULL) {
  na_vec <- c("NA", "NULL","_", "none", "N/A", "")
  sheets = readxl::excel_sheets(ram_path)
  lst = vector("list", length(sheets))
  i = 1
  # read in all the dataframes

  for (s in sheets) {
    if (s == "Timeseries_values_view") {

      # this sheet is generating warnings

      col_type_vec <- c(rep("text", 3), rep("numeric", 9))
        lst[[i]] = readxl::read_excel(path = ram_path, sheet = s, na = na_vec, col_types = col_type_vec)
    }
      lst[[i]] = readxl::read_excel(path = ram_path, sheet = s, na = na_vec)
      i <- i+1
    }

  names(lst) <- sheets
  # write all dataframes as rdata objects
  write_path <- file.path(ram_dir(vers = version), paste0("v", version, ".RDS"))
  saveRDS(lst, file = write_path)
}


