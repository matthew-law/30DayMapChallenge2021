### POPULATION CARTOGRAM 

library(eurostat)
library(tidyverse)
library(sf)
library(cartogram)
library(paletteer)

# get the data: NUTS2 regions + their populations -------------------------

# NUTS2 regions
nuts2_sf <- get_eurostat_geospatial(output_class = 'sf',
                                    resolution = '60', nuts_level = 2)

# populations
nuts2_pop <- get_eurostat("tgs00096", stringsAsFactors = F)

nuts2_pop_19 <- nuts2_pop %>% 
  filter(time == "2019-01-01") #%>% 

nrow(nuts2_pop_19)
nrow(nuts2_sf)

# add missing Northern Ireland population
nuts2_pop_19 <- nuts2_pop_19 %>% add_row(geo = "UKN0", values = 1885000)

# join the population data to the sf
nuts2_sf_pop <- nuts2_sf %>% 
  left_join(nuts2_pop_19, by = "geo") %>% 
  st_crop(c(xmin = -25, ymin = 31, xmax = 48, ymax = 72)) %>% 
  st_transform(3857) # change CRS to EPSG 3857 (uses metres as unit)

plot(nuts2_sf_pop$geometry, col='blue') # missing BiH, Kosovo

# double check for NA values
nuts2_sf_pop[is.na(nuts2_sf_pop$values),]

# make a cartogram! -------------------------------------------------------

cartogram <- cartogram_cont(nuts2_sf_pop, "values", itermax=7)

ggplot(cartogram) +
  geom_sf(aes(fill = CNTR_CODE, alpha = 0.3), show.legend = FALSE, size = 0.3) +
  scale_fill_paletteer_d("pals::polychrome") +
  labs(title = "European population", subtitle="in each NUTS2 region in 2019",
       caption = "Data from Eurostat via {eurostat} package in R") +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#f5f5f4", color = NA), 
    text=element_text(family="HK Grotesk"),
    plot.title = element_text(size= 30, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 16, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.caption = element_text(size= 12, color = "#4e4d47", hjust = 0.95, margin = margin(t = 0.4, r = 2, b = 0.2, unit = "cm"))
  )