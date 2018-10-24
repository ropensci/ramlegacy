.onAttach <- function(libname, pkgname) {
  latest_vers <- sprintf("%.1f", as.numeric(det_version()))
  vers_to_load = sprintf("%.1f", as.numeric(check_local()))
  num_vers <- length(dir(ram_dir(),  pattern = "\\d[.0-9]{,3}"))
  if (num_vers == 0) {
    not_completed("No version of RAM Legacy Stock Assessment Database has yet been downloaded. Use function download_ramlegacy to download a version now.")
    return(invisible(TRUE))
  } else if (num_vers > 1) {
      if (vers_to_load == latest_vers) {
        not_completed(paste("Multiple versions found including the latest one. Loading latest version",
                            det_version()))
        download_ramlegacy()
        load_ramlegacy(version = latest_vers)
      } else {
        choice_list <- dir(ram_dir(), pattern = "\\d[.0-9]{,3}")
        vers_list <- paste(choice_list, collapse = " ")
        completed(paste("Found these versions", vers_list))
        ans <- sprintf("%.1f", ask_multiple("Select the version to load.", choice_list))
        load_ramlegacy(ans)
      }
  } else if (vers_to_load < latest_vers) {
    notify(paste0("Loading version v", vers_to_load,
                  ". Be informed that a newer version ",
                  latest_vers,
                  " of the database is available."))
    load_ramlegacy(version = vers_to_load)
  }
  invisible(TRUE)
}
