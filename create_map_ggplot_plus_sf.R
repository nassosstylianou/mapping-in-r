
library(sf)

con.votes.constituency <- readr::read_csv('data/general_election_conservative_party_london_results_2017.csv')
sf.constituency <- sf::st_read('shp/Westminster_Parliamentary_Constituencies_December_2015_Generalised_Clipped_Boundaries_in_Great_Britain.shp') %>%
  sf::st_transform(4326)

names(sf.constituency)
names(con.votes.constituency)

sf.constituency.join <- dplyr::left_join(con.votes.constituency,
                                         sf.constituency,
                                         by = c("Code" = "pcon15cd")) 

ggplot2::ggplot(data = sf.constituency.join) + 
  ggplot2::theme_void() + 
  ggplot2::theme(panel.grid.major = element_line(colour = "transparent"), axis.text = element_blank()) +
  geom_sf(aes(fill = as.numeric(`Candidate Votes`)), col = "NA") + 
  scale_fill_gradientn(colours = c("#f1eef6", "#a6bddb", "#74a9cf", "#3690c0","#0570b0", "#034e7b"), limits = c(0, 35000)) + ggtitle("Conservative voting totals, 2017 election (SF)") +
  theme(plot.title = element_text(face="bold", size=12, hjust=0, color="#555555")) + coord_sf(crs = 4326)


