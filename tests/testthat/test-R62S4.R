library(testthat)

context("R62S4")

test_that("no generic",{
  expect_silent(R62S4(NoGeneric, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(printer(NoGeneric$new(), "Hello World"), "Hello World")
  expect_error(excluder(NoGeneric$new()))
  expect_equal(Status(NoGeneric$new()), "Printing")
  expect_true(length(methods::.S4methods("printer")) > 0)
})

test_that("S4 generic",{
  expect_silent(R62S4(S4Generic, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(upper(S4Generic$new(), "hello world"), "HELLO WORLD")
  expect_error(excluder(S4Generic$new()))
  expect_equal(Status(S4Generic$new()), "Printing")
  expect_true(length(methods::.S4methods("upper")) > 0)
})
