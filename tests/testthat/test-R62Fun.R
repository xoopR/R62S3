library(testthat)

context("R62Fun")

nogen <- R6::R6Class("nogen",public = list(printer = function(y) print(y)))
test_that("no generic",{
  expect_silent(R62Fun(nogen, assignEnvir = parent.env(environment())))
  expect_equal(printer(nogen$new(),"Test No Gen"), "Test No Gen")
})
