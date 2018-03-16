
con.votes.constituency <- readr::read_csv('data/general_election_conservative_party_london_results_2017.csv')

london_constituency_shp <- readOGR(dsn = "shp/london_constituencies.shp", 
                            layer = "london_constituencies", 
                            stringsAsFactors=FALSE, 
                            encoding="utf-8")

head(london_constituency_shp@data)
head(london_constituency_shp@polygons)


tidy <- tidy(london_constituency_shp)

constituency_codes <- london_constituency_shp$pcon15cd
con.votes.constituency %<>% arrange(match(Code, constituency_codes))
con.votes.constituency$id <- 0:72

plot_data <- merge(tidy(london_constituency_shp), con.votes.constituency, by = "id", all.x=T) %>%
  arrange(id) 

head(plot_data)

ggplot(data=plot_data, 
       aes(x=long, y=lat, group=group)) + 
  geom_polygon(aes(fill = `Candidate Votes`), col = "NA") +
  theme_void() +
  ggtitle("Conservative voting totals, 2017 election (Pure GGPLOT)") +
  theme(plot.title = element_text(face="bold", size=12, hjust=0, color="#555555")) +
  scale_fill_gradientn(colours = c("#f1eef6", "#a6bddb", "#74a9cf", "#3690c0","#0570b0", "#034e7b"), limits = c(0, 35000))

