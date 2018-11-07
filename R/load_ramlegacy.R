
#' load_ramlegacy
#'
#' @param version version number of the database that should be loaded. If not specified then it defaults to the latest version.
#' @param path path to the local directory where ram legacy database is stored. This path can be viewed using the function \code{ram_dir}
#' @return None
#' @export
#'
#' @examples
load_ramlegacy <- function(version = NULL, path = NULL) {
  ram_url = "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  if (!is.null(version)) {
    version <- sprintf("%.1f", as.numeric(version))
    check_version_arg(version)
  } else {
    version <- find_latest(ram_url)
  }
  if(is.null(path)) {
    path <- file.path(ram_dir(vers = version),paste0("v", version, ".rds"))
  } else {
    check_download_path(path)
  }
  notify(paste("Loading version", version))
  # make sure version is present
  if (!file.exists(path)) {
    stop(paste0("Version ", version, " not found locally"))
  }

  # read in the list of dataframes
  list_dataframes <- readRDS(path)

  names(list_dataframes) <- paste0(names(list_dataframes), "_v", version)

  lapply(seq_along(list_dataframes),
         function(i) {
           delayedAssign(names(list_dataframes)[i], list_dataframes[[i]], assign.env = .GlobalEnv)
         })
  log_vec <- unlist(lapply(names(list_dataframes),
                    function(i) {
                      exists(i, envir = .GlobalEnv)
                      }))
  if(all(log_vec)) {
    completed(paste0("Version ", version, " has been successfully loaded."))
  } else {
    not_completed(paste0("Version ", version, "failed to load"))
  }
  invisible(TRUE)
}

