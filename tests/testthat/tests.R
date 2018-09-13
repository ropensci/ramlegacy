# Includes tests for download function and
# the auxiliary functions called by it: check_version() & check_format()
library(testthat)

context("Check download arguments")

test_that("check_version with valid versions", {
  expect_true(check_version(3))
  expect_true(check_version(3.0))
  expect_true(check_version(2.5))
  expect_true(check_version(2.0))
  expect_true(check_version(1.0))
})


test_that("check_version fails with invalid versions", {

  expect_error(check_version(1.1))
  expect_error(check_sides(1.5))
  expect_error(check_sides(2.5))
  expect_error(check_sides(3.5))
  expect_error(check_sides(4.0))
})


test_that("check_format fails with invalid formats", {
  expect_error(check_format('Excel'), "Invalid format. Format can only be excel or access.")
  expect_error(check_format('Access'), "Invalid format. Format can only be excel or access.")
  expect_error(check_format('zip'), "Invalid format. Format can only be excel or access.")
  expect_error(check_format('xlsx'), "Invalid format. Format can only be excel or access.")
  expect_error(check_format('json'), "Invalid format. Format can only be excel or access.")
  expect_error(check_format('sql'), "Invalid format. Format can only be excel or access.")

})

test_that("check_format works with valid formats", {

  expect_true(check_format('excel'))
  expect_true(check_format('access'))
})








