# Includes tests for download function and
# the auxiliary functions called by it: check_version() & check_format()

context("Check download_ramlegacy works")

test_that("downloading ramlegacy fails behind a proxy server with informative error message",{
  skip_on_cran()
  httr::set_config(httr::use_proxy(url = "http://google.com", port = 1234), override = TRUE)
  base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  expect_error(ramlegacy:::net_check(base_url), message = "Could not connect to the internet. Please check your connection settings and try again.")
  httr::reset_config()
})


test_that("check_format fails with invalid formats", {
  expect_error(check_format("Excel"),
               "Invalid format. Format can only be 'excel' or 'access'.")
  expect_error(check_format("Access"),
               "Invalid format. Format can only be 'excel' or 'access'.")
  expect_error(check_format("zip"),
               "Invalid format. Format can only be 'excel' or 'access'.")
  expect_error(check_format("xlsx"),
               "Invalid format. Format can only be 'excel' or 'access'.")
  expect_error(check_format("json"),
               "Invalid format. Format can only be 'excel' or 'access'.")
  expect_error(check_format("sql"),
               "Invalid format. Format can only be 'excel' or 'access'.")

})

test_that("check_format works with valid formats", {

  expect_true(check_format("excel"))
  expect_true(check_format("access"))
})

test_that("download fails with invalid location", {
  expect_error(download(path = 3.0))
})

# Tests for read and show_sheet functions

context("Check read works")

