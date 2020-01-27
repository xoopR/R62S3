library(testthat)

context("R62S3")

test_that("no generic",{
  expect_error(isS3stdGeneric("R62S3printer"))
  expect_silent(R62S3(R62S3_NoGeneric, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(R62S3printer(R62S3_NoGeneric$new(), "Hello World"), "Hello World")
  expect_error(excluder(R62S3_NoGeneric$new()))
  expect_equal(R62S3StatusC(R62S3_NoGeneric$new()), "Printing")
  # expect_true(isS3stdGeneric("R62S3printer"))
})

test_that("S3 generic",{
  # expect_true(isS3stdGeneric("R62S3lower"))
  expect_silent(R62S3(R62S3_S3Generic, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(R62S3lower(R62S3_S3Generic$new(), "HELLO WORLD"), "hello world")
  expect_error(excluder(R62S3_S3Generic$new()))
  expect_equal(R62S3StatusA(R62S3_S3Generic$new()), "Printing")
})
