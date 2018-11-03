# private function to check version argument
check_version_arg <- function(version) {
  latest_vers <- find_latest()
  list_vers <- c("1.0", "2.0", "2.5", "3.0", "4.3")
  version <- sprintf("%.1f", as.numeric(version))
  if (!latest_vers %in% list_vers) {
    list_vers <- c(list_vers, latest_vers)
  }
  if (!version %in% list_vers) {
    list_vers <- paste0(c("1.0", "2.0", "2.5", "3.0", "4.3"), ",")
    list_vers <- paste(list_vers, collapse = " ")
    stop(paste("Invalid version number. Available versions are", list_vers), call. = FALSE)
  }
  invisible(TRUE)
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
    stop("`path` must be a string", call. = FALSE)
  }
  TRUE
}

#' @title Output OS-independent path to the downloaded database
#'
#' @description Provides the download location for \link{download_ramlegacy} in an OS independent manner.
#'
#' @param vers Version Number. Has to be specified
#'
#' @examples \dontrun{
#' ram_dir()
#' }
#'
#' @export
#'
#'
ram_dir <- function(vers = NULL){
  if (!is.null(vers)) {
    vers <- sprintf("%.1f", as.numeric(vers))
    check_version_arg(vers)
  }
  rappdirs::user_data_dir("ramlegacy", version = vers)
}

## Ask for yes or no
#' @noRd
ask_yn <- function(...) {
  choices <- c("Yes", "No")
  cat(crayon::green(paste0(...,"\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::menu(choices) == which(choices == "Yes")
}


## Ask for multiple choices
#' @noRd
ask_multiple <- function(msg, choices) {
  cat(crayon::green(paste0(msg,"\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::menu(choices)
}


# Catch 'network timeout error' or 'could not resolve host error' generated
# when dealing with proxy-related or connection related
# issues and fail with an informative error
# message
#' @noRd
net_check <- function(url, show_error = FALSE){
 response <- tryCatch(httr::GET(url),
  error = function(e) {
      if(show_error) {
        stop("Could not connect to the internet. Please check your connection settings and try again.", call. = FALSE)
      }
    })
  if(typeof(response) == "list") invisible(TRUE) else invisible(FALSE)
}

# regex function to find the latest version from the web, return it as a string
#' @noRd
find_latest <- function(ram_url) {
  if (!net_check(ram_url)) {
    return("4.3")
  }
  req <- httr::GET(ram_url)
  if (req$status_code == 200) {
    # httr::GET the content
    contnt <- httr::content(req, "text")
    # httr::GET all the links
    m <- gregexpr("RLSADB_v[0-9]\\.[0-9]+_[()_a-zA-Z0-9]+_excel.zip",
                  text = contnt )
    links <- unlist(regmatches(contnt, m))
    # httr::GET the latest href
    latest_link <- tail(links, 1)
    ## httr::GET newest version from latest_link
    m_vers <- gregexpr("\\d\\.\\d+", text = latest_link)
    version <- unlist(regmatches(latest_link, m_vers))
    return(version)
  } else {
    return(version)
  }
}


# write latest version as metadata to rappdirs directory
#' @noRd
write_version <- function(path, version) {
  version <- sprintf("%.1f", as.numeric(version))
  if(!dir.exists(path)) {
    dir.create(path)
  }
  writePath <- file.path(path, "VERSION.txt")
  writeLines(version, writePath)
}


# Returns the version (as a string) to load
# find_local should return a vector of string versions instead
# of a single string
#' @noRd
find_local <- function(path, latest_vers) {
  # httr::GET the number of versions in rappdirs
  num_vers <- length(dir(path, pattern = "\\d[.0-9]{1,3}"))
  local_vers <- dir(path, pattern = "\\d[.0-9]{1,3}")
  if (num_vers == 0) {
    return(NULL)
  } else if(num_vers > 1 && latest_vers %in% local_vers) {
    return(latest_vers)
  } else {
    return(local_vers)
  }
}



