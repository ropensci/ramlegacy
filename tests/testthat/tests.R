# Includes tests for download function and
# the auxiliary functions called by it: check_version() & check_format()

context("Check download_ramlegacy works")


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

