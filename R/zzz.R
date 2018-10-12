.onAttach <- function(libname, pkgname) {
  
  if (interactive()) {
      packageStartupMessage(
        not_completed("RAM Legacy Stock Assessment Database has not yet been downloaded. Use download_ramlegacy() to download it now.")
      )
    }
}

.onLoad <- function(libname, pkgname) {
  read_ramlegacy()