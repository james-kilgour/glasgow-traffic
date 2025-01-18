# ------------------------------------------------------------------------------
# Traffic analysis in Glasgow

# Using open data from the council's open data portal:
# https://developer.glasgow.gov.uk/api-details#api=traffic&operation=6303582e2bca805cda07be52

# and some other resourcesfrom Christian Pascual and Kate Pyper, PhD

# ------------------------------------------------------------------------------


# 1. Housekeeping ---------------------------------------------------------

install.packages(httr)
install.packages(jsonlite)


library(httr)
library(jsonlite)
library(tidyverse)


# Pulling data: -----------------------------------------------------------

# Okay so, after playing around with the API some, 


site_ids <- GET("http://api.glasgow.gov.uk/traffic/v1/movement/sites")

site_ids <- fromJSON(rawToChar(site_ids$content))


res <- GET(
	url = "http://api.glasgow.gov.uk/traffic/v1/movement/query", 
	query = list(size = "168", 
							 format = "json",
							 start = "2025-01-01",
							 end = "2025-01-07",
							 period = "Hour"))


data = fromJSON(rawToChar(res$content))




data$measurements$flow

data$measurements$concentration


data$history$averages



start_date <- as.Date("2023-12-31")


for (x in 1:366){
	
	date <- start_date %m+% lubridate::days(x)
	
	print(date)
	
	
}



