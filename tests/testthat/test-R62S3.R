library(testthat)

context("R62S3")

nogen <- R6::R6Class("nogen",public = list(printer = function() return("Test No Gen")))
test_that("no generic",{
  expect_silent(R62S3(nogen, assignEnvir = .GlobalEnv))
  expect_equal(printer(nogen$new()), "Test No Gen")
  expect_silent(get("printer"))
  expect_silent(get("printer.nogen"))
})

gen <- R6::R6Class("gen",public = list(print = function() return("Test Gen")))

test_that("generic",{
  expect_silent(R62S3(gen, assignEnvir = .GlobalEnv))
  expect_equal(print(gen$new()), "Test Gen")
  expect_silent(get("print.gen"))
  expect_silent(get("print"))
})

masker <- R6::R6Class("masker",public = list(pdf = function() return("Test masker")))

test_that("mask FALSE",{
  expect_silent(R62S3(masker, assignEnvir = .GlobalEnv, mask = FALSE))
  expect_error(pdf(masker$new()))
  expect_equal(pdf.masker(masker$new()), "Test masker")
})

masker <- R6::R6Class("masker",public = list(pdf = function() return("Test masker")))

test_that("mask TRUE",{
  expect_silent(R62S3(masker, assignEnvir = .GlobalEnv, mask = TRUE))
  expect_equal(pdf(masker$new()), "Test masker")
  expect_equal(pdf.masker(masker$new()), "Test masker")
})
