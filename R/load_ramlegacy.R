
#' load_ramlegacy
#'
#' @param version version number of the database that should be loaded. If not specified then it defaults to the latest version.
#' @param path path to the directory where ram legacy database is stored
#' @return None
#' @export
#'
#' @examples
load_ramlegacy <- function(version = NULL, vers_path = NULL) {
  ram_url = "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  if (!is.null(version)) {
    version <- sprintf("%.1f", as.numeric(version))
    check_version_arg(version)
  } else {
    version <- find_latest(ram_url)
    version <- sprintf("%.1f", as.numeric(version))
  }
  if(is.null(path)) {
    path <- ram_dir(vers = version)
  } else {
    check
  }
  read_path <- file.path(ram_dir(vers = version),
                         paste0("v", version, ".RDS"))
  # make sure version is present
  if (!file.exists(ram_dir(vers))) {
    stop("Error in loading: version not found")
  }
  list_dataframes <- readRDS(read_path)

  names(list_dataframes) <- paste0(names(list_dataframes), "_v", version)
  lapply(seq_along(lst_dfs),
         function(i) {
           delayedAssign(names(list_dataframes)[i], list_dataframes[[i]], assign.env = .GlobalEnv)
         }
  )
  invisible(TRUE)
}

