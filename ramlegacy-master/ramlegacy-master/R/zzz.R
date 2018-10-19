.onAttach <- function(libname, pkgname) {
  det_version()
  vers_to_load = check_local()
  if (is.null(vers_to_load)) {
    not_completed("No version of RAM Legacy Stock Assessment Database has yet been downloaded. Use function download_ramlegacy to download a version now.")
  } else {
    if (vers_to_load < latest_vers) {
      notify(paste0("Be informed that a newer version v",
                    latest_vers,
                    " of the database is available."))
    }
    load_ramlegacy(version = vers_to_load)
  }
}
