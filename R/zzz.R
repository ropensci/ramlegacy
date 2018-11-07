.onAttach <- function(libname, pkgname) {
  latest_version <- find_latest()
  write_version(path = ram_dir(), version = latest_version)
  local_vers <- find_local(path = ram_dir(), latest_vers = latest_version)
  if (is.null(local_vers)) {
    not_completed(paste("No version of RAM Legacy Stock Assessment Database has yet been downloaded.",
                        "Use function download_ramlegacy to download a version now.", sep = "\n"))
  } else if (length(local_vers) > 1) {
    ask_list <- paste0(local_vers, ",")
    display_list <- paste(ask_list, collapse = " ")
    completed(paste("Found these versions", display_list))
    ans <- ask_multiple("Select the version to load.", local_vers)
    ans <- sprintf("%.1f", as.numeric(ans))
    load_ramlegacy(version = ans)
  } else if (local_vers == latest_version) {
      notify(paste("Multiple versions found including the latest one.",
                          latest_vers))
      load_ramlegacy(version = latest_version)
  } else {
    notify(paste0("Be informed that a newer version ",
                  latest_version,
                  " of the database is available."))
    load_ramlegacy(version = local_vers)
  }
  invisible(TRUE)
}
