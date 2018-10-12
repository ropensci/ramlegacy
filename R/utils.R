# private function to check version number
check_version <- function(version) {
  if (!version %in% c(3, 3.0, 2.5, 2.0, 1.0, 4.3)) {
    stop("Invalid version number", call. = FALSE)
  }
  TRUE
}

# private function to check string
is_string <- function(x) {
  length(x) == 1 && is.character(x)
}

# private function to check format
check_format <- function(format) {
  if (!format %in% c("excel", "access")) {
    stop("Invalid format. Format can only be 'excel' or 'access'.", call. = FALSE)
  }
  TRUE
}

# private function to check path is valid or not
check_download_path <- function(path) {
  if (!is_string(path)) {
    stop("`ram_path` must be a string", call. = FALSE)
  }
  TRUE
}

#' @title Output OS-independent path to the zipped ramlegacy database 
#'
#' @description Provides the download location for \link{download_ramlegacy} in an OS independent manner.
#' 
#' @param ... arguments potentially passed to \code{rappdirs::user_data_dir}
#' 
#' @examples \dontrun{
#' ram_dir()
#' }
#'
#' @export
#'
#'
ram_dir <- function(vers){
  rappdirs::user_data_dir("ramlegacy", version = vers)
}

## Ask for something
#' @noRd
ask <- function(...) {
  choices <- c("Yes", "No")
  cat(crayon::green(paste0(...,"\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::menu(choices) == which(choices == "Yes")
}


# Catch network timeout error or not resolve host error generated
# when dealing with proxy-related connection
# issues and fail with an informative error
# message
#' @noRd
net_check <- function(url){
  tryCatch(httr::GET(url),
           error = function(e) {
             if(grepl("Timeout was reached:", e$message) | grepl("Could not resolve host:", e$message)) {
               stop("Could not connect to the internet. Please check your connection settings and try again.", call. = FALSE)
             }
           }
  )}