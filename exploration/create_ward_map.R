# Make UK ward map

sf.countries <- sf::st_read('shp/Countries_December_2015_Generalised_Clipped_Boundaries_in_Great_Britain.shp') %>%
  sf::st_transform(4326)
sf.regions <- sf::st_read('shp/Regions_December_2016_Ultra_Generalised_Clipped_Boundaries_in_England.shp') %>%
  sf::st_transform(4326)

sf.wards <- sf::st_read('shp/Wards_December_2016_Super_Generalised_Clipped_Boundaries_in_Great_Britain.shp') %>% 
  sf::st_transform(4326)

data.wards <- readr::read_csv('data/idt_england_wales_latest.csv') %>%
  dplyr::mutate(range = car::recode(changereal, "-65:-25='big_decrease'; -25:0='small_decrease'; 0:25='slight_increase'; 25:40='increase'; 40:250='big_increase'"))

names(sf.wards)
names(data.wards)

sf.ward.join <- dplyr::left_join(data.wards,
                                 sf.wards,
                                 by = c("ward" = "wd16cd")) 


ggplot2::ggplot(data = sf.ward.join) +
  ggplot2::theme_minimal() + 
  ggplot2::theme(panel.grid.major = element_line(colour = "transparent"),
                 axis.text = element_blank()) +
  geom_sf(aes(fill = range), col = "NA") +
  geom_sf(data = sf.regions, fill = "NA", col = "#000000", size = 0.2) + 
  geom_sf(data = sf.countries, fill = "NA", col = "#000000", size = 0.1) +
  scale_fill_manual(values = c("big_increase" = "#542788", "small_decrease" = "#998ec3", "slight_increase" = "#d8daeb", "increase" = "#f1a340", "big_decrease" = "#b35806"))
