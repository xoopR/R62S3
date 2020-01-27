library(testthat)

context("R62S4")

test_that("no generic",{
  expect_silent(R62S4(R62S4_NoGeneric, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(R62S4printer(R62S4_NoGeneric$new(), "Hello World"), "Hello World")
  expect_error(excluder(R62S4_NoGeneric$new()))
  expect_equal(R62S4Status(R62S4_NoGeneric$new()), "Printing")
  expect_true(length(methods::.S4methods("R62S4printer")) > 0)
})

test_that("S4 generic",{
  expect_silent(R62S4(R62S4_S4Generic, assignEnvir = topenv(), exclude = "excluder", scope = c("public","active")))
  expect_equal(R62S4upper(R62S4_S4Generic$new(), "hello world"), "HELLO WORLD")
  expect_error(excluder(R62S4_S4Generic$new()))
  expect_equal(R62S4Status(R62S4_S4Generic$new()), "Printing")
  expect_true(length(methods::.S4methods("R62S4upper")) > 0)
})
