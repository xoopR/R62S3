library(testthat)

context("R62S3")

nogen <- R6::R6Class("nogen",public = list(printer = function() return("Test No Gen")))
test_that("no generic",{
  expect_silent(R62S3(nogen, assignEnvir = topenv()))
  expect_equal(printer(nogen$new()), "Test No Gen")
  expect_silent(get("printer"))
  expect_silent(get("printer.nogen"))
})

gen <- R6::R6Class("gen",public = list(print = function() return("Test Gen")))

test_that("generic",{
  expect_silent(R62S3(gen, assignEnvir = topenv()))
  expect_equal(print(gen$new()), "Test Gen")
  expect_silent(get("print.gen"))
  expect_silent(get("print"))
})

# masker <- R6::R6Class("masker",public = list(abs = function() return("Test masker")))
#
# test_that("mask FALSE",{
#   expect_silent(R62S3(masker, assignEnvir = topenv(), mask = FALSE))
#   expect_equal(abs.masker(masker$new()), "Test masker")
# })

masker <- R6::R6Class("masker",public = list(pdf = function() return("Test masker")))

test_that("mask TRUE gen",{
  expect_silent(R62S3(masker, assignEnvir = topenv(), mask = TRUE))
  expect_equal(pdf(masker$new()), "Test masker")
  expect_equal(pdf.masker(masker$new()), "Test masker")
})

printer <- R6::R6Class("masker",public = list(print = function() return("Test printer")))

test_that("mask TRUE s3gen",{
  expect_silent(R62S3(printer, assignEnvir = topenv(), mask = TRUE))
  expect_equal(print(printer$new()), "Test printer")
  expect_equal(print.masker(printer$new()), "Test printer")
})

printer <- R6::R6Class("printer",public = list(prints = function() return("Test printer")))

test_that("mask TRUE no gen",{
  expect_silent(R62S3(printer, assignEnvir = topenv(), mask = TRUE))
  expect_equal(prints(printer$new()), "Test printer")
  expect_equal(prints.printer(printer$new()), "Test printer")
})
