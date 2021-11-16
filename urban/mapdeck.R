### mapdeck experiment

library(mapdeck)
library(sf)
library(dplyr)

set_token('your Mapbox key (replace this bit)')

buildingparts <- st_read('buildingpart_selection.gpkg')

buildingparts <- buildingparts %>% filter(numberOfFloorsAboveGround >= 1)

buildingparts$e <- buildingparts$numberOfFloorsAboveGround * 3

plot(buildingparts$geom) # looks okay to me

mapdeck(zoom = 18, location = c(2.173052, 41.389061), bearing = 135, pitch = 45) %>%
  add_polygon(
    data = buildingparts
    , layer = "polygon_layer"
    , fill_colour = "e"
    , fill_opacity = ( 255 / 2 )
    , elevation = "e"
  )
