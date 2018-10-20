load_ramlegacy <- function(version = NULL) {
  version <- as.numeric(version)
  read_path <- file.path(ram_dir(vers = version),
                         paste0("v", sprintf("%.1f", version), ".RDS"))
  lst_dfs <- readRDS(read_path)

  names(lst_dfs) <- paste0(names(lst_dfs), "_v", sprintf("%.1f", version))
  lapply(seq_along(lst_dfs),
         function(x) {
           delayedAssign(names(lst_dfs)[x], lst_dfs[[x]], eval.env = parent.env(), assign.env = .GlobalEnv)
         }
  )
  invisible(TRUE)
}
