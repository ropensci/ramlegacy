
#' @name load_ramlegacy
#' @title Read-in downloaded RAM Legacy Database
#' @description Returns a list of all the dataframes present in the specified
#'  version of the database.
#' @param version A character vector of length 1 specifying the version number of the
#'  database. As of January 2019, the available versions are
#'  "1.0", "2.0", "2.5", "3.0", "4.3", and "4.4". If version argument is not specified then it
#'  defaults to latest version (currently "4.4"). If you want to load multiple versions please
#'  load them one at a time as passing them all at once will throw an error.
#' @param ram_path path to the local directory where the specified version of
#' the RAM Legacy Stock Excel Assessment Database was downloaded.
#'  By default this path is set to can be viewed using calling the function \code{\link{ram_dir}} and specifying
#'  the version number inside the function call. This function \strong{does not} support
#'  setting a user-specified path so \strong{please
#'  do not pass} in a path argument to \code{path}.
#' @export
#'
#' @examples
#' \dontrun{
#' # If version is not specified then current latest version
#' # (4.4) will be loaded
#' load_ramlegacy()
#'
#' # load version 3.0
#' load_ramlegacy(version = "3.0")
#'
#' # load version 2.5
#' load_ramlegacy(version = "2.5")
#' }
#'
load_ramlegacy <- function(version = NULL, ram_path = NULL) {
  ram_url <- "https://doi.org/10.5281/zenodo.2542918"

  if (!is.null(version)) {
    # ensure that the version is properly formatted
    version <- fmt_version(version)
    check_version_arg(version)
  } else {
    version <- find_latest(ram_url)
  }

  if (is.null(ram_path)) {

    if (version < "4.40") {
      rds_path <- file.path(ram_dir(vers = version), paste0("v", version, ".rds"))

      } else {

      rds_path <- file.path(ram_dir(vers = version), paste0("RLSADB v", version))
      rds_path <- file.path(rds_path, "DB Files With Assessment Data")
      rds_path <- file.path(rds_path, paste0("v", version, ".rds"))

      }

  } else {

    check_path(ram_path)
    rds_path <- ram_path

    }

  # make sure version is present
  if (!file.exists(rds_path)) {
    stop(paste0("Version ", version, " not found locally."))
  }

  list_dataframes <- readRDS(rds_path)
  return(list_dataframes)
}
