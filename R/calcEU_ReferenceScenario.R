calcEU_ReferenceScenario <- function() {

  euRef2016 <- readSource("EU_ReferenceScenario", subtype = "2016")

  # convert EUR2013 -> US$2017
  tmp <- GDPuc::toolConvertGDP(
    gdp = euRef2016[, , "Price|Secondary Energy|Electricity (EUR2013/GJ)"],
    unit_in = "constant 2013 EUR",
    unit_out = mrdrivers::toolGetUnitDollar(),
    replace_NAs = "with_USA"
  )

  getNames(tmp) <- "Price|Secondary Energy|Electricity (US$2017/GJ)"
  euRef2016 <- euRef2016[, , "Price|Secondary Energy|Electricity (EUR2013/GJ)", invert = TRUE]
  euRef2016 <- mbind(euRef2016, tmp)

  euRef2016 <- add_dimension(euRef2016, dim = 3.1, add = "model", nm = "EU_ReferenceScenario_2016")

  euRef2020 <- readSource("EU_ReferenceScenario", subtype = "2020")

  # convert EUR2015 -> US$2017
  tmp <- GDPuc::toolConvertGDP(
    gdp = euRef2020[, , "Price|Secondary Energy|Electricity (EUR2015/GJ)"],
    unit_in = "constant 2015 EUR",
    unit_out = mrdrivers::toolGetUnitDollar(),
    replace_NAs = "with_USA"
  )

  getNames(tmp) <- "Price|Secondary Energy|Electricity (US$2017/GJ)"
  euRef2020 <- euRef2020[, , "Price|Secondary Energy|Electricity (EUR2015/GJ)", invert = TRUE]
  euRef2020 <- mbind(euRef2020, tmp)

  euRef2020 <- add_columns(euRef2020, "y2000", dim = 2)
  euRef2020 <- add_dimension(euRef2020, dim = 3.1, add = "model", nm = "EU_ReferenceScenario_2020")

  x <- mbind(euRef2016, euRef2020)

  weights <- x
  weights[, , ] <- NA
  weights[, , "Price|Secondary Energy|Electricity (US$2017/GJ)"] <- 1

  return(list(
    x = x, weight = weights, mixed_aggregation = TRUE,
    unit = "Various", description = "Historical Data"
  ))
}
