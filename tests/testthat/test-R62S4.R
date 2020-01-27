library(testthat)

context("R62S4")

nogen <- R6::R6Class("nogen",public = list(printer = function(y) print(y)))
test_that("no generic",{
  expect_silent(R62S4(nogen, assignEnvir = topenv()))
  expect_true(isGeneric("printer"))
  expect_true(any(grepl("nogen",methods("printer"))))
  expect_equal(printer(nogen$new(),"Test No Gen"), "Test No Gen")
})

methods::setGeneric("s4print",
                    def = function(object, ...){},
                    where = topenv())
gen <- R6::R6Class("gen",public = list(s4print = function(y) print(y)))
test_that("generic",{
  expect_silent(R62S4(gen, assignEnvir = topenv()))
  expect_equal(s4print(gen$new(), "Test Gen"), "Test Gen")
  expect_true(isGeneric("s4print"))
  expect_true(any(grepl("gen",methods("s4print"))))
})

# masker <- R6::R6Class("masker",public = list(pdf = function() return("Test masker")))
#
# test_that("mask FALSE",{
#   R62S4(masker, mask = FALSE, assignEnvir = .GlobalEnv)
# })

masker <- R6::R6Class("masker",public = list(pdf = function() return("Test masker")))

test_that("mask TRUE",{
  expect_silent(R62S4(masker, mask = TRUE, assignEnvir = topenv()))
  expect_equal(pdf(masker$new()), "Test masker")
})

