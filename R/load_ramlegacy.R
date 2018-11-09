
#' @name load_ramlegacy
#' @title Read-in downloaded RAM Legacy Database
#' @description Loads all the dataframes present in the specified version of the database into
#'  user's global environment
#' @param version A character vector of length 1 specifying the version number of the
#'  database. So far available versions are
#'  1.0, 2.0, 2.5, 3.0 and 4.3. If version argument is not specified then it
#'  defaults to latest version (currently 4.3). Note that this function
#'  does not support vectorization so please \strong{don't pass in a vector of
#'  version numbers} to \code{version}
#' @param path path to the local directory where the specified version of
#' the RAM Legacy Stock Excel Assesment database was downloaded.
#'  This path can be viewed using calling the function \code{\link{ram_dir}} and specifying
#'  the version number inside the function call. This function \strong{does not} support
#'  setting a user-specified path so \strong{please
#'  do not pass} in a path argument to \code{path}.
#' @export
#'
#' @examples
#' \dontrun {
#' # If version is not specified then current latest version (4.3) will be loaded
#' load_ramlegacy()
#'
#' # load version 3.0
#' load_ramlegacy(version = "3.0")
#'
#' # load version 2.5
#' load_ramlegacy(version = "2.5)
#' }

load_ramlegacy <- function(version = NULL, path = NULL) {
  ram_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  if (!is.null(version)) {
    version <- sprintf("%.1f", as.numeric(version))
    check_version_arg(version)
  } else {
    version <- find_latest(ram_url)
  }
  if(is.null(path)) {
    path <- file.path(ram_dir(vers = version),paste0("v", version, ".rds"))
  } else {
    check_path(path)
  }
  notify(paste("Loading version", version, "..."))
  # make sure version is present
  if (!file.exists(path)) {
    stop(paste0("Version ", version, " not found locally."))
  }

  # read in the list of dataframes
  list_dataframes <- readRDS(path)

  names(list_dataframes) <- paste0(names(list_dataframes), "_v", version)

  lapply(seq_along(list_dataframes),
         function(i) {
           delayedAssign(names(list_dataframes)[i],
                         list_dataframes[[i]], assign.env = .GlobalEnv)
         })
  exists_vec <- unlist(lapply(names(list_dataframes),
                    function(i) {
                      exists(i, envir = .GlobalEnv)
                      }))
  if (all(exists_vec)) {
    completed(paste0("Version ", version, " has been successfully loaded."))
  } else {
    not_completed(paste0("Version ", version, "failed to load."))
  }
  invisible(TRUE)
}

