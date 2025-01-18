# ------------------------------------------------------------------------------
# Traffic analysis in Glasgow

# Using open data from the council's open data portal:
# https://developer.glasgow.gov.uk/api-details#api=traffic&operation=6303582e2bca805cda07be52

# and some other resources from Christian Pascual and Kate Pyper, PhD
# ------------------------------------------------------------------------------


# 1. Housekeeping ---------------------------------------------------------

install.packages(httr)
install.packages(jsonlite)


library(httr)
library(jsonlite)
library(tidyverse)


# 2. Pulling data: -----------------------------------------------------------

# We're going to visualise hourly traffic flows in Glasgow. To do this, we need
# to create a nested For loop. The following code pulls establishes some 
# reference data we'll use later on:

# 2.1 Setting reference data
site_id <- GET("http://api.glasgow.gov.uk/traffic/v1/movement/sites") 

site_id <- fromJSON(rawToChar(site_id$content)) %>% 
	select(siteId) %>% 
	pull(siteId)


# Glasgow city council maintains 1275 individual traffic flow monitor camera things
# (I'm not sure what they're called), but in order for us to accurately measure
# the whole Glasgow city traffic system, we can't rely on the aggregated data 
# output provided by the query. As such, side_id will help us filter for 
# specific sites and pull traffic data at a more granular level.

start_date <- as.Date("2023-12-31")

# 2.2 Building the looped API query

traffic_data

for (i in 1:366){
	
	for (j in 1:length(site_id)){
		
		date_1 <- start_date %m+% lubridate::days(i)
		date_2 <- start_date %m+% lubridate::days(i+1)
	
		api_query <- GET(
			url = "http://api.glasgow.gov.uk/traffic/v1/movement/query", 
			query = list(size = "24", 
									 format = "json",
									 start = date_1,
									 end = date_2,
									 period = "Hour",
									 id = j))
		
		
		temp_data = fromJSON(rawToChar(api_query$content))
		
		temp_data <- as.data.frame(do.call(rbind, lapply(temp_data$measurements$flow, as.data.frame))) %>% 
			filter(calculation == "Mean") %>% 
			mutate(hour = row_number(),
						 siteId = j,
						 date = i) 
		
		traffic_data <- rbind(traffic_data, temp_data)
		
	}
	
}



res <- GET(
	url = "http://api.glasgow.gov.uk/traffic/v1/movement/query", 
	query = list(size = "24", 
							 format = "json",
							 start = "2025-01-01",
							 end = "2025-01-02",
							 period = "Hour"))


data = fromJSON(rawToChar(res$content))


temp_data <- as.data.frame(do.call(rbind, lapply(data$measurements$flow, as.data.frame))) %>% 
	filter(calculation == "Mean") %>% 
	mutate(hour = row_number(),
				 siteId = "an id",
				 date = "a date") 


data$measurements$flow %>% 
	mutate(position = position)





# pausing this for now





