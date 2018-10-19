completed <- function(msg){
  packageStartupMessage(crayon::green(cli::symbol$smiley), " ", msg)
}

not_completed <- function(msg){
  packageStartupMessage(crayon::red(cli::symbol$cross), " ", msg)
}

notify <- function(msg){
  packageStartupMessage(crayon::blue(cli::symbol$info), " ", msg)
}
