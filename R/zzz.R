.onAttach <- function(libname, pkgname) {
  write_version()
  latest_vers <- find_latest()
  local_vers <- find_local()
  if (is.null(local_vers)) {
    not_completed("No version of RAM Legacy Stock Assessment Database has yet been downloaded. Use function download_ramlegacy to download a version now.")
  } else if (length(local_vers) > 1) {
    ask_list <- paste0(local_vers, ",")
    display_list <- paste(choice_list, collapse = " ")
    completed(paste("Found these versions", display_list))
    ans <- sprintf("%.1f", ask_multiple("Select the version to load.", local_vers))
    load_ramlegacy(ans)
  } else if (local_vers == latest_vers) {
      notify(paste("Multiple versions found including the latest one. Loading latest version",
                          latest_vers))
      load_ramlegacy(latest_vers)
  } else {
    notify(paste0("Loading version ", local_vers,
                  ". Be informed that a newer version ",
                  latest_vers,
                  " of the database is available."))
    load_ramlegacy(local_vers)
  }
  invisible(TRUE)
}
