context("Testing function in utils.R")

test_that("ram_dir returns a path",{
  expect_is(ram_dir(), "character")
  expect_is(ram_dir(vers = 2.0), "character")
})

test_that("check_version_arg works with valid versions", {
  expect_true(check_version_arg(3.0))
  expect_true(check_version_arg(2.5))
  expect_true(check_version_arg(2.0))
  expect_true(check_version_arg(1.0))
  expect_true(check_version_arg(4.3))
})


test_that("check_version_arg fails with invalid versions", {

  expect_error(check_version_arg(1.1), grep(Invalid version number. Available versions are"Invalid")
  expect_error(check_version_arg(1.5))
  expect_error(check_version_arg(2.4))
  expect_error(check_version_arg(3.5))
  expect_error(check_version_arg(4.0))
})
