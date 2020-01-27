library(testthat)

context("R62Fun")

test_that("no generic",{
  expect_silent(R62Fun(R62Fun_NoGeneric, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(printer(R62Fun_NoGeneric$new(), "Hello World"), "Hello World")
  expect_error(excluder(R62Fun_NoGeneric$new()))
  expect_equal(Status(R62Fun_NoGeneric$new()), "Printing")
  expect_true(length(methods::.S4methods("printer")) == 0)
  expect_error(utils::isS3stdGeneric("printer"))
})
