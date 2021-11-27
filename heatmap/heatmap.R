### Heatmap

# read data (from http://www.hills-database.co.uk/downloads.html)
peaks <- read_csv("DoBIH_v17_2.csv")

# filter to just marilyns
marilyns <- peaks %>% 
  filter(Ma == 1) # http://www.hills-database.co.uk/database_notes.html for metadata

# have a look at the points (this bit optional)
marilyns_sf <- st_as_sf(marilyns, coords = c("Longitude", "Latitude"), crs = 4326)
plot(marilyns_sf$geometry)

# plot map
get_stamenmap(bbox = c(-11, 49.5, 2.5, 61),
              zoom = 6, maptype = "toner-background") %>% # nice clean background map
  ggmap() +
  stat_density2d_filled(
    data = marilyns,
    aes(x = Longitude, y = Latitude, alpha = ..level..),
    n = 400,
    bins = 8, # number of colours used
    breaks = c(0, 0.002, 0.005, 0.02, 0.03, 0.05, 0.07, 0.09, 0.1100), # play with these as desired
    geom = "polygon") + 
  scale_fill_manual(values = pals::kovesi.isoluminant_cm_70_c39(8)) + # change the coour palette
  scale_alpha_discrete(range = c(0.4,0.8)) + # change transparency range
  theme_void() + # get rid of chart junk
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm")) +
  guides(alpha = FALSE, fill = F) # get rid of legends

ggsave('heatmap.png', height = 3000, units = "px")
knitr::plot_crop('heatmap.png')

# I did try to add the title/subtitle/data credit in R but gave up because 
# I couldn't (quickly/easily) get them to plot over the map itself, and I could 
# do the same thing 10x quicker and easier in PowerPoint (my secret shame)

# if you really want to do everything in R, try something like the below 
# (but if not just add the labels in Paint or PowerPoint or whatever)

map <- image_read('heatmap.png')

print(map)
image_annotate(map, 
               'Marilyns in the UK and Ireland', 
               font = 'HK Grotesk', size = 85, color = 'white', location = "+100+100")