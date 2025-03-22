library(tidyverse)


#Performing cluster analysis to find strength of collaborations per country
#We exported this data to Tableau to better visualize the geographic breakdown of our analysis
#See presentation in ReadMe for visualizations

#2019
set.seed(1234)

cluster_data <- read_csv("D:/BA Practicum/Nineteen.csv")

#Label which songs have collaborations
nineteen_data_collab <- cluster_data %>% mutate(is_collaboration = ifelse(
  str_detect(artist, ",") | 
    str_detect(title, "\\(feat\\.") |
    str_detect(title, "featuring") |
    str_detect(title, "\\(with\\)"), 1, 0))

nineteen_data_collab$region <- as.factor(nineteen_data_collab$region)
region_one_hot <- model.matrix(~ region - 1, data = nineteen_data_collab)

nineteen_data <- cbind(nineteen_data_collab, region_one_hot)
cluster_data <- nineteen_data %>% select(streams, rank, is_collaboration, c(13:78))

normalized_data <- scale(cluster_data)
normalized_data <- as.data.frame(normalized_data)

normalized_data_sample <- normalized_data %>% sample_n(10000)


library(factoextra)

fviz_nbclust(normalized_data_sample, kmeans, method = "wss")

kmeans_cluster <- kmeans(normalized_data_sample, centers = 10, nstart = 25) 

normalized_data_sample$cluster <- kmeans_cluster$cluster

cluster_summary <- normalized_data_sample %>%
  group_by(cluster) %>%
  summarize(
    avg_streams = mean(streams, na.rm = TRUE),
    avg_rank = mean(rank, na.rm = TRUE),
    num_collaborations = mean(is_collaboration, na.rm = TRUE),
    across(starts_with("region"), ~ sum(.) / n(), .names = "prop_{col}")  # Proportion of each region
  )

cluster_summary %>% View

cluster_max_collab <- cluster_summary %>%
  filter(avg_rank > 0.1) %>% filter(num_collaborations == max(num_collaborations, na.rm = TRUE))

collab_cluster_data <- normalized_data_sample %>%
  filter(cluster == cluster_max_collab$cluster)

region_summary<- collab_cluster_data %>%
  summarise(across(starts_with("region"), sum, na.rm = TRUE)) %>%
  pivot_longer(cols = starts_with("region"), names_to = "region", values_to = "count") %>%
  arrange(desc(count))

region_summary %>% View

write.csv(region_summary, "D:/BA Practicum/cluster19.csv", row.names = T)

#2020
cluster_data20 <- read_csv("D:/BA Practicum/Twenty.csv")
twenty_data_collab <- cluster_data20 %>% mutate(is_collaboration = ifelse(
  str_detect(artist, ",") | 
    str_detect(title, "\\(feat\\.") |
    str_detect(title, "featuring") |
    str_detect(title, "\\(with\\)"), 1, 0))

twenty_data_collab$region <- as.factor(twenty_data_collab$region)
region_one_hot20 <- model.matrix(~ region - 1, data = twenty_data_collab)

twenty_data<- cbind(twenty_data_collab, region_one_hot20)
cluster_data20 <- twenty_data %>% select(streams, rank, is_collaboration, c(13:80))

twenty_data <- as.data.frame(cluster_data20)

normalized_data_sample20 <- twenty_data %>% sample_n(10000)
normalized_data20 <- scale(normalized_data_sample20) %>% as.data.frame()

set.seed(1234)

library(factoextra)

##fviz_nbclust(normalized_data20, kmeans, method = "wss")

kmeans_cluster20 <- kmeans(normalized_data20, centers = 10, nstart = 25) 

normalized_data20$cluster <- kmeans_cluster20$cluster


cluster_summary20 %>% View  <- normalized_data20 %>%
  group_by(cluster) %>%
  summarize(
    avg_streams = mean(streams, na.rm = TRUE),
    avg_rank = mean(rank, na.rm = TRUE),
    num_collaborations = mean(is_collaboration, na.rm = TRUE),
    across(starts_with("region"), ~ sum(.) / n(), .names = "prop_{col}")  # Proportion of each region
  )



cluster_max_collab20 <- cluster_summary20 %>%
  filter(num_collaborations == max(num_collaborations, na.rm = TRUE))

collab_cluster_data20<- normalized_data20 %>%
  filter(cluster == 5)

region_summary20 <- collab_cluster_data20 %>%
  summarise(across(starts_with("region"), sum, na.rm = TRUE)) %>%
  pivot_longer(cols = starts_with("region"), names_to = "region", values_to = "count") %>%
  arrange(desc(count))

write.csv(region_summary20, "D:/BA Practicum/Cluster20.csv", row.names=T)


#2021
twentyone_data_collab$region <- as.factor(twentyone_data_collab$region)
region_one_hot21 <- model.matrix(~ region - 1, data = twentyone_data_collab)

twentyone_data<- cbind(twentyone_data_collab, region_one_hot21)
cluster_data21 <- twentyone_data %>% select(streams, rank, is_collaboration, c(13:73))

normalized_data <- scale(cluster_data21)
normalized_data <- as.data.frame(normalized_data)

normalized_data_sample21 <- normalized_data %>% sample_n(10000)

set.seed(1234)
library(factoextra)

##fviz_nbclust(normalized_data_sample21, kmeans, method = "wss")
kmeans_cluster21 <- kmeans(normalized_data_sample21, centers = 8, nstart = 25) 

normalized_data_sample21$cluster <- kmeans_cluster21$cluster

cluster_summary21<- normalized_data_sample21 %>%
  group_by(cluster) %>%
  summarize(
    avg_streams = mean(streams, na.rm = TRUE),
    avg_rank = mean(rank, na.rm = TRUE),
    num_collaborations = mean(is_collaboration, na.rm = TRUE),
    across(starts_with("region"), ~ sum(.) / n(), .names = "prop_{col}")  # Proportion of each region
  )

cluster_summary21 %>% View


cluster_max_collab21 <- cluster_summary21 %>%
  filter(num_collaborations == max(num_collaborations, na.rm = TRUE))

collab_cluster_data21<- normalized_data_sample21 %>%
  filter(avg_rank>0.1) %>% filter(cluster== cluster_max_collab21)

region_summary21<- collab_cluster_data21 %>%
  summarise(across(starts_with("region"), sum, na.rm = TRUE)) %>%
  pivot_longer(cols = starts_with("region"), names_to = "region", values_to = "count") %>%
  arrange(desc(count))

region_summary21 %>% View

write.csv(region_summary21, "D:/BA Practicum/cluster21.csv", row.names = T)


