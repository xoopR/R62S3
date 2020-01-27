library(testthat)

context("R62Fun")

nogen <- R6::R6Class("nogen",public = list(printer = function(y) print(y)))
test_that("no generic",{
  expect_silent(R62Fun(nogen, assignEnvir = topenv()))
  expect_equal(printer(nogen$new(),"Test No Gen"), "Test No Gen")
})

varMask <- R6::R6Class("varMask",public = list(abs = function(y) return(y)))
test_that("mask TRUE",{
  expect_silent(R62Fun(varMask, assignEnvir = topenv(), mask = TRUE))
  expect_equal(get("abs",envir = topenv())(varMask$new(),"Test Mask"), "Test Mask")
})

# covMask <- R6::R6Class("covMask",public = list(cov = function(y) return(y)))
# test_that("mask FALSE",{
#   expect_silent(R62Fun(covMask, assignEnvir = topenv()))
#   expect_equal(get("cov.covMask",envir= topenv())(covMask$new(),"Test Mask"), "Test Mask")
#   expect_error(cov(covMask$new(),"Test Mask"))
# })

noGenMask <- R6::R6Class("noGenMask",public = list(sd = function(y) return(y)))
test_that("Gen FALSE mask TRUE",{
  expect_silent(R62Fun(noGenMask, assignEnvir = topenv(),
                detectGeneric = T, mask = T))
  expect_equal(sd(noGenMask$new(),"Test Mask"), "Test Mask")
  expect_error(sd.noGenMask(noGenMask$new()))
})

