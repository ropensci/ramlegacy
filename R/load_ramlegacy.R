
#' load_ramlegacy
#'
#' @param version version number of the database that should be loaded
#'
#' @return None
#' @export
#'
#' @examples
load_ramlegacy <- function(version = NULL) {
  version <- sprintf("%.1f", as.numeric(version))
  read_path <- file.path(ram_dir(vers = version),
                         paste0("v", version, ".RDS"))
  lst_dfs <- readRDS(read_path)

  names(lst_dfs) <- paste0(names(lst_dfs), "_v", version)
  lapply(seq_along(lst_dfs),
         function(x) {
           delayedAssign(names(lst_dfs)[x], lst_dfs[[x]], assign.env = .GlobalEnv)
         }
  )
  invisible(TRUE)
}

