library(testthat)

context("R62S3")

nogen <- R6::R6Class("nogen",public = list(lbind = function() return("Test No Gen")))
test_that("no generic",{
  expect_silent(R62S3(nogen, assignEnvir = .GlobalEnv))
  expect_equal(lbind(nogen$new()), "Test No Gen")
  expect_silent(get("lbind"))
  expect_silent(get("lbind.nogen"))
})

gen <- R6::R6Class("gen",public = list(rbind = function() return("Test Gen")))

test_that("generic",{
  expect_silent(R62S3(gen, assignEnvir = .GlobalEnv))
  expect_equal(rbind(gen$new()), "Test Gen")
  expect_silent(get("rbind.gen"))
  expect_silent(get("rbind"))
})
