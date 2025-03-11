library(tidyverse)
library(lubridate)
charts <- read_csv("C:/Users/luker/OneDrive - Tulane University/Desktop/Business Analytics Practicum/Music Project/charts.csv", na = c("", "NULL"))

#Selecting only the rows in the top200 category
top200 <- charts %>% filter(chart == "top200")
top200 %>% View

#Filtering data by year to make RStudio load variables faster
year_top200 <- top200 %>% mutate(year = format(date, "%Y"))

Seventeen_data <- year_top200 %>%  filter(year == 2017)
#write.csv(Seventeen_data, "C:/Users/samue/OneDrive/Escritorio/TUL FA 24/BA Practicum/Seventeen1.csv", row.names = T)
Eighteen_data <- year_top200 %>% filter(year == 2018)
#write.csv(Eighteen_data, "C:/Users/samue/OneDrive/Escritorio/TUL FA 24/BA Practicum/Eighteen.csv", row.names = T)
Nineteen_data <- year_top200 %>% filter(year== 2019)
#write.csv(Nineteen_data, "C:/Users/samue/OneDrive/Escritorio/TUL FA 24/BA Practicum/Nineteen.csv", row.names = T)
Twenty_data <- year_top200 %>% filter(year== 2020)
#write.csv(Twenty_data, "D:/BA Practicum/Twenty.csv", row.names = T)
Twentyone_data <- year_top200 %>% filter(year== 2021)
#write.csv(Twentyone_data, "D:/BA Practicum/Twenty one.csv", row.names = T)
Twentytwo_data <- year_top200 %>% filter(year== 2022)
#write.csv(Twentytwo_data, "D:/BA Practicum/Twenty two.csv", row.names = T)

#Finding the artists on the top200 on the most countries, then filtering by 25th-30th positions
#to find an example of an artist who is not as famous.

#Explanation of code:
    #For every dataset per year, we are grouping by region and artist, getting the total stream for
    #every artist, and then filtering artists so that we only get those with more than 5 songs on the top200.

    #After we get the results for every region/artist group, we are getting only those on the 25th-30th ranking.
    #Once we have that dataset, we are counting how many times every artist appears across regions.

    
svntn_artists <- Seventeen_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% slice(25:30) %>% ungroup() %>% count(artist, sort = T)

egtn_artists <- Eighteen_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% slice(25:30) %>% ungroup() %>% count(artist, sort = T)

ntn_artists <- Nineteen_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% slice(25:30) %>% ungroup() %>% count(artist, sort = T)

twnt_artists <- Twenty_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% slice(25:30) %>% ungroup() %>% count(artist, sort = T)

twntone_artists <- Twentyone_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% slice(25:30) %>% ungroup() %>% count(artist, sort = T)

repeated_artists <- svntn_artists %>% semi_join(egtn_artists, by = "artist") %>% semi_join(ntn_artists, by = "artist") %>% 
  semi_join(twnt_artists, by = "artist") %>% semi_join(twntone_artists, by = "artist")
repeated_artists %>% View


#Checking the countries with the most streams for BTS alone.
#Since we chose BTS, this  code per year looks at BTS's presence across regions specifically.
#2017
BTS17 <- Seventeen_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% filter(artist == "BTS")

#dropping the first row since it is a generic "global"
BTS17_dropped <- BTS17[-1,]

#Finding the percentage of streams from our target countries compared the total streams globally
total_stream_17 <- BTS17_dropped %>% ungroup() %>% summarize(sum(total_stream))

#India and Mexico do not have Spotify until 2019
#india_streams17 <- BTS17_dropped %>% ungroup() %>% filter(region == "India") %>% select(total_stream)
#india_streams17/total_stream_17 

#mexico_streams17 <- BTS17_dropped %>% ungroup() %>% filter(region == "Mexico") %>% select(total_stream)
#mexico_streams17/total_stream_17

brazil_streams17 <- BTS17_dropped %>% ungroup() %>% filter(region == "Brazil") %>% select(total_stream)
brazil_streams17/total_stream_17

peru_streams17 <- BTS17_dropped %>% ungroup() %>% filter(region == "Peru") %>% select(total_stream)
peru_streams17/total_stream_17

chile_streams17 <- BTS17_dropped %>% ungroup() %>% filter(region == "Chile") %>% select(total_stream)
chile_streams17/total_stream_17

#2018
BTS18 <- Eighteen_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% filter(artist == "BTS")
BTS18_dropped <- BTS18[-1,]

total_stream_18 <- BTS18_dropped %>% ungroup() %>% summarize(sum(total_stream))

#india_streams18 <- BTS18_dropped %>% ungroup() %>% filter(region == "India") %>% select(total_stream)
#india_streams18/total_stream_18 

#mexico_streams18 <- BTS18_dropped %>% ungroup() %>% filter(region == "Mexico") %>% select(total_stream)
#mexico_streams18/total_stream_18

brazil_streams18 <- BTS18_dropped %>% ungroup() %>% filter(region == "Brazil") %>% select(total_stream)
brazil_streams18/total_stream_18

peru_streams18 <- BTS18_dropped %>% ungroup() %>% filter(region == "Peru") %>% select(total_stream)
peru_streams18/total_stream_18

chile_streams18 <- BTS18_dropped %>% ungroup() %>% filter(region == "Chile") %>% select(total_stream)
chile_streams18/total_stream_18

#2019
BTS19 <- Nineteen_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% filter(artist == "BTS")
BTS19_dropped <- BTS19[-1,]

total_stream_19 <- BTS19_dropped %>% ungroup() %>% summarize(sum(total_stream))

india_streams19 <- BTS19_dropped %>% ungroup() %>% filter(region == "India") %>% select(total_stream)
india_streams19/total_stream_19

mexico_streams19 <- BTS19_dropped %>% ungroup() %>% filter(region == "Mexico") %>% select(total_stream)
mexico_streams19/total_stream_19

brazil_streams19 <- BTS19_dropped %>% ungroup() %>% filter(region == "Brazil") %>% select(total_stream)
brazil_streams19/total_stream_19

peru_streams19 <- BTS19_dropped %>% ungroup() %>% filter(region == "Peru") %>% select(total_stream)
peru_streams19/total_stream_19

chile_streams19 <- BTS19_dropped %>% ungroup() %>% filter(region == "Chile") %>% select(total_stream)
chile_streams19/total_stream_19

#2020. 
BTS20 <- Twenty_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% filter(artist == "BTS")
BTS20_dropped <- BTS20[-1,]

total_stream_20 <- BTS20_dropped %>% ungroup() %>% summarize(sum(total_stream))

india_streams20 <- BTS20_dropped %>% ungroup() %>% filter(region == "India") %>% select(total_stream)
india_streams20/total_stream_20

mexico_streams20 <- BTS20_dropped %>% ungroup() %>% filter(region == "Mexico") %>% select(total_stream)
mexico_streams20/total_stream_20

brazil_streams20 <- BTS20_dropped %>% ungroup() %>% filter(region == "Brazil") %>% select(total_stream)
brazil_streams20/total_stream_20

peru_streams20 <- BTS20_dropped %>% ungroup() %>% filter(region == "Peru") %>% select(total_stream)
peru_streams/total_stream

chile_streams20 <- BTS20_dropped %>% ungroup() %>% filter(region == "Chile") %>% select(total_stream)
chile_streams/total_stream

#2021
BTS21 <- Twentyone_data %>% group_by(region, artist) %>% summarize(total_stream = sum(streams),
  songs = n_distinct(title)) %>% filter(songs > 5) %>% 
  arrange(desc(total_stream)) %>% filter(artist == "BTS")
BTS21_clean <- BTS21[-1,]

#GRAPH BTS21 to show dropoff in streams. India will be added to the recommendations
#India spiked in popularity in 2021.
india_streams <- BTS21_clean %>% ungroup() %>% filter(region == "India") %>% select(total_stream)
total_stream <- BTS21_clean %>% ungroup() %>% summarize(sum(total_stream))
india_streams/total_stream

brazil_streams <- BTS21_clean %>% ungroup() %>% filter(region == "Brazil") %>% select(total_stream)
brazil_streams/total_stream

mexico_streams <- BTS21_clean %>% ungroup() %>% filter(region == "Mexico") %>% select(total_stream)
mexico_streams/total_stream

peru_streams <- BTS21_clean %>% ungroup() %>% filter(region == "Peru") %>% select(total_stream)
peru_streams/total_stream

chile_streams <- BTS21_clean %>% ungroup() %>% filter(region == "Chile") %>% select(total_stream)
chile_streams/total_stream
#Getting Setlist for India

#top streamed India songs in 2019
setlist_nineteen <- Nineteen_data %>% filter(region == "India", artist == "BTS") %>% group_by(artist, title, region, year) %>% summarize(total_stream = sum(streams)) %>% arrange(desc(total_stream))

#top streamed India songs in 2020
setlist_twenty <- Twenty_data %>% filter(region == "India", artist == "BTS") %>% group_by(artist, title, region, year) %>% summarize(total_stream = sum(streams)) %>% arrange(desc(total_stream))

#top streamed India songs in 2021
setlist_twentyone <- Twentyone_data %>% filter(region == "India", artist == "BTS") %>% group_by(artist, title, region, year) %>% summarize(total_stream = sum(streams)) %>% arrange(desc(total_stream))

#combine all years
full_setlist <- rbind(setlist_nineteen, setlist_twenty, setlist_twentyone) %>% ungroup() %>% group_by(artist, title, region)

#get most streamed songs from 2019-2021 in India
cumulative_top_songs <- full_setlist %>%
  group_by(title) %>%
  summarise(
    total_cumulative_stream = sum(total_stream)
  ) %>% arrange(desc(total_cumulative_stream)) %>% view()

top_songs_three_yrs <- cumulative_top_songs %>%
  slice_max(order_by = total_cumulative_stream, n = 20) %>%
  
  top_songs_three_yrs_thousands <- top_songs_three_yrs %>%
  mutate(total_cumulative_stream_k = total_cumulative_stream / 1000)

ggplot(top_songs_three_yrs_thousands, aes(x = reorder(title, total_cumulative_stream_k),
                                          y = total_cumulative_stream_k)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top Songs in India",
    x = "Song Title",
    y = "Cumulative Streams (Thousands)"
  ) +
  theme_minimal()

#get most streamed songs from 2019-2021 in India
cumulative_top_songs <- full_setlist %>%
  group_by(title) %>%
  summarise(
    total_cumulative_stream = sum(total_stream)
  ) %>% arrange(desc(total_cumulative_stream)) %>% view()

top_songs_three_yrs <- cumulative_top_songs %>%
slice_max(order_by = total_cumulative_stream, n = 20)
  
  top_songs_three_yrs_thousands <- top_songs_three_yrs %>%
  mutate(total_cumulative_stream_k = total_cumulative_stream / 1000)

ggplot(top_songs_three_yrs_thousands, aes(x = reorder(title, total_cumulative_stream_k),
                                          y = total_cumulative_stream_k)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top Songs in India",
    x = "Song Title",
    y = "Cumulative Streams (Thousands)"
  ) +
  theme_minimal()

