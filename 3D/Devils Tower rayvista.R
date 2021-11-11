### Devils Tower
# code almost entirely stolen/repurposed from Hugh Graham

library(rayvista)
library(rayshader)
library(terrainr)
library(sf)

DT_area <- data.frame(id = seq(1, 100, 1),
                      lat = runif(100, 44.584, 44.595),
                      lng = runif(100, -104.723, -104.707)) %>%
  st_as_sf(., coords = c("lng", "lat")) %>%
  st_set_crs(., 4326)?

DT_tiles <- get_tiles(DT_area,
                     services = c("elevation"),
                     resolution = 1)

plot <- plot_3d_vista(dem=DT_tiles$elevation, overlay_detail = 16, zscale=1,
                      windowsize=800, zoom=0.8, theta=240, phi=25, solid=F)

render_movie('exports/DT_movie', type = 'orbit', frames = 720, fps = 30, vignette = c(0.7, 0.5))