library(testthat)

context("R62Fun")

test_that("no generic",{
  expect_silent(R62Fun(NoGeneric, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(printer(NoGeneric$new(), "Hello World"), "Hello World")
  expect_error(excluder(NoGeneric$new()))
  expect_equal(Status(NoGeneric$new()), "Printing")
  expect_true(length(methods::.S4methods("printer")) == 0)
  expect_false(utils::isS3stdGeneric("printer"))
})
