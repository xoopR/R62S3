library(testthat)

context("R62S3")

test_that("no generic",{
  expect_silent(R62S3(NoGeneric, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(printer(NoGeneric$new(), "Hello World"), "Hello World")
  expect_error(excluder(NoGeneric$new()))
  expect_equal(Status(NoGeneric$new()), "Printing")
  expect_true(utils::isS3stdGeneric("printer"))
})

test_that("S3 generic",{
  expect_silent(R62S3(S3Generic, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(lower(S3Generic$new(), "HELLO WORLD"), "hello world")
  expect_error(excluder(S3Generic$new()))
  expect_equal(Status(S3Generic$new()), "Printing")
  expect_true(utils::isS3stdGeneric("lower"))
})
