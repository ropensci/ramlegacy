context("Testing functions in utils.R")

ram_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"

test_that("net_check doesn't error behind proxy server with show_error as F", {
  httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234), {
    expect_silent(net_check(ram_url, show_error = FALSE))
    expect_false(net_check(ram_url, show_error = FALSE))
  })
})

test_that("net_check errors behind proxy server with show_error as TRUE", {
  httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234), {
    expect_error(
      net_check(ram_url, show_error = TRUE),
      paste(
        "Could not connect to the internet.",
        "Please check your connection settings and try again."
      )
    )
  })
})

test_that("net_check works when no connection issues w/ show_error as TRUE", {
  expect_silent(net_check(ram_url, show_error = TRUE))
  expect_true(net_check(ram_url, show_error = TRUE))
})

test_that("net_check works when no connection issues w/ show_error as FALSE", {
  expect_silent(net_check(ram_url, show_error = FALSE))
  expect_true(net_check(ram_url, show_error = FALSE))
})

test_that("net_check doesn't error when no net connection w/ show_error as F", {
  httptest::without_internet({
    expect_silent(net_check(ram_url, show_error = FALSE))
    expect_false(net_check(ram_url, show_error = FALSE))
  })
})

test_that("net_check errors if no internet connection with show_error as T", {
  httptest::without_internet({
    expect_error(
      net_check(ram_url, show_error = TRUE),
      paste(
        "Could not connect to the internet.",
        "Please check your connection settings and try again."
      )
    )
  })
})

# test_that("find_latest behaves correctly", {
#   skip_on_cran()
#   test_url1 <- "http://httpbin.org/status/300"
#   test_url3 <- "http://httpbin.org/status/404"
#   test_url4 <- "http://httpbin.org/status/500"
#
#   # test find_latest with no internet connection
#   httptest::without_internet({
#     expect_silent(find_latest(ram_url))
#     expect_equal(find_latest(ram_url), "4.3")
#   })
#   # test find_latest behaves as expected with proxy connection issues
#   httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234), {
#     expect_silent(find_latest(ram_url))
#     expect_equal(find_latest(ram_url), "4.3")
#   })
#   # test find_latest behaves as expected when response has failed
#   expect_equal(find_latest(test_url1), "4.3")
#   expect_equal(find_latest(test_url3), "4.3")
#   expect_equal(find_latest(test_url4), "4.3")
# })
#
# test_that("write_version works as expected", {
#   skip_on_cran()
#   # create temp directory as a proxy for rappdirs directory
#   test_path <- tempfile("ramlegacy", tempdir())
#   # check test_path doesn't exist before calling write_version
#   expect_false(dir.exists(test_path))
#   # call write_version
#   write_version(test_path, "4.3")
#   # check test_path has been created after calling write_version
#   expect_true(dir.exists(test_path))
#   txt_path <- file.path(test_path, "VERSION.txt")
#   expect_true(file.exists(txt_path))
#   expect_equal(readLines(txt_path), "4.3")
#   unlink(txt_path, recursive = TRUE)
#
#   # check that write_version ovewrites the latest version correctly
#   dir.create(test_path, showWarnings = FALSE, recursive = TRUE)
#   file.create(txt_path)
#   writeLines(txt_path, "4.3")
#   write_version(test_path, "5.0")
#   expect_equal(readLines(txt_path), "5.0")
#
#   # remove the contents of the temp paths
#   unlink(test_path, recursive = TRUE)
#
#   # check the behavior of write_version when ramlegacy path is present
#   dir.create(test_path, showWarnings = FALSE, recursive = TRUE)
#
#   # check directory is present and created and that write_version
#   # shouldn't create it
#   expect_true(dir.exists(test_path))
#   write_version(test_path, "2.0")
#   expect_true(file.exists(txt_path))
#   expect_equal(readLines(txt_path), "2.0")
#
#   # remove the contents of the temp paths
#   unlink(test_path, recursive = TRUE)
# })
#
# test_that("find_local behaves as expected", {
#   skip_on_cran()
#   # use tempdir to mock rappdirs directory
#   test_path <- tempfile("ramlegacy", tempdir())
#   dir.create(test_path, showWarnings = FALSE, recursive = TRUE)
#   expect_null(find_local(test_path, "4.3"))
#   # put a single version in this directory
#   version_path2.5 <- file.path(test_path, "2.5/v2.5.rds")
#   dir.create(version_path2.5, showWarnings = F, recursive = T)
#   expect_equal(find_local(test_path, "4.3"), "2.5")
#
#   # put multiple versions (not including latest) in the directory
#   # to check if it returns a vector of the versions
#   version_path1.0 <- file.path(test_path, "1.0/v1.0.rds")
#   version_path2.0 <- file.path(test_path, "2.0/v2.0.rds")
#   version_path3.0 <- file.path(test_path, "3.0/v3.0.rds")
#   dir.create(version_path1.0, showWarnings = FALSE, recursive = TRUE)
#   dir.create(version_path2.0, showWarnings = FALSE, recursive = TRUE)
#   dir.create(version_path3.0, showWarnings = FALSE, recursive = TRUE)
#   set1 <- unlist(strsplit(find_local(test_path, "4.3"), split = " "))
#   set2 <- c("2.5", "1.0", "2.0", "3.0")
#   expect_true(setequal(set1, set2))
#
#   # check if it returns latest_vers when it is present in dir
#   version_path4.3 <- file.path(test_path, "4.3/v4.3.rds")
#   dir.create(version_path4.3, showWarnings = FALSE, recursive = TRUE)
#   expect_equal(find_local(test_path, "4.3"), "4.3")
# })
#
# test_that("ram_dir returns a path", {
#   expect_is(ram_dir(), "character")
#   expect_is(ram_dir(vers = 2.0), "character")
#   expect_silent(ram_dir())
# })
#
# test_that("check_version_arg works with valid versions", {
#   expect_true(check_version_arg(3.0))
#   expect_true(check_version_arg(2.5))
#   expect_true(check_version_arg(2.0))
#   expect_true(check_version_arg(1.0))
#   expect_true(check_version_arg(4.3))
# })
#
#
# test_that("check_version_arg fails with invalid versions", {
#   expect_error(
#     check_version_arg(1.1),
#     "Invalid version number. Available versions are"
#   )
#   expect_error(
#     check_version_arg(1.5),
#     "Invalid version number. Available versions are"
#   )
#   expect_error(
#     check_version_arg(2.4),
#     "Invalid version number. Available versions are"
#   )
#   expect_error(
#     check_version_arg(3.5),
#     "Invalid version number. Available versions are"
#   )
#   expect_error(
#     check_version_arg(4.0),
#     "Invalid version number. Available versions are"
#   )
#   expect_error(
#     check_version_arg(c("3.5", "2.0")),
#     "Please pass in only one version number."
#   )
# })
#
# test_that("check_path works with valid paths", {
#   expect_true(check_path(path = ram_dir()))
#   expect_true(check_path(path = ram_dir(vers = 1.0)))
#   expect_true(check_path(path = ram_dir(vers = 2.0)))
#   expect_true(check_path(path = ram_dir(vers = 2.5)))
#   expect_true(check_path(path = ram_dir(vers = 3.0)))
#   expect_true(check_path(path = ram_dir(vers = 4.3)))
#   expect_true(check_path(path = tempfile("ramlegacy", tempdir())))
# })
#
# test_that("check_path errors out with invalid paths", {
#   expect_error(check_path(2.0))
# })
