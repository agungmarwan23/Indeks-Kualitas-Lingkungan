library(readr)
library(cluster)
library(factoextra)
library(tidyverse)
library(gridExtra)
library(Hmisc)
library(ggplot2)
library(fmsb)
if(!require(pacman)) install.packages("pacman")
pacman::p_load("tidyverse", "raster", "sp", "sf",
               "scales", "ggsn", "dbscan", "rgdal",
               "RSQLite", "plotly", "mapview", "leaflet",
               "spdep", "spatialreg", "lmtest")
### From Github
if (!require("rspatial")) remotes::install_github('rspatial/rspatial');
library(rspatial)

require(sf)
library('sf')

library(RStoolbox)
library(raster)
library(sp)
library(factoextra)
library(tictoc)
library(RColorBrewer)
library(tmap)
library("maps")
library(leaflet)

#INPUT DATA KEDALAM R
setwd("D:/2024/Datathon/Pengolahan Data/IKL 2022/")
df <- read_csv("Data_Merge_2022.csv")
dataku <- df[,17:25]


#MELIHAT SUMMARY DARI DATA
summary(dataku)

#MEMBUAT HISTOGRAM PERSEBARAN DATA

#Histogram 1
hist.data.frame(dataku)

#Histogram 2
dataku <- dataku[, sapply(dataku, is.numeric)]
dataku_long <- pivot_longer(dataku, everything(), names_to = "Variable", values_to = "Value")
ggplot(data = dataku_long, aes(x = Value, fill = Variable)) +
  geom_histogram(binwidth = 0.01, color = "black", position = "identity", alpha = 0.5) +
  facet_wrap(~Variable, scales = "free") +
  labs(title = "Histogram of All Columns", x = "Value", y = "Frequency") +
  theme_minimal()

#Histogram 3
num_cols <- 3  # Jumlah kolom dalam tata letak
num_rows <- ceiling(ncol(dataku) / num_cols)  # Jumlah baris dalam tata letak

# Atur tata letak plot
par(mfrow = c(num_rows, num_cols))
# Loop melalui setiap kolom dalam dataframe
for (col in names(dataku)) {
  # Buat histogram
  hist(dataku[[col]], breaks = "Sturges", prob = TRUE, main = col, xlab = col)
  
  # Tambahkan plot density
  lines(density(dataku[[col]]), col = "blue")
}
# Reset tata letak plot ke aslinya
par(mfrow = c(1, 1))


# PROSES MELAKUKAN K-MEANS CLUSTERING

#Menggunakan metode elbow, siku siku terbentuk pada jumlah k = 3
fviz_nbclust(dataku, kmeans, method = "wss")

#Menggunakan metode sihouette, siku siku terbentuk pada jumlah k = 2
fviz_nbclust(dataku, kmeans, method = "silhouette")

#Menggunakan metode gap_stat, siku siku terbentuk pada jumlah k = 10
#fviz_nbclust(dataku, kmeans, method = "gap_stat")

#Membuat visualisi perbandingan untuk k=2 sampai dengan k=5
k2 <- kmeans(dataku, centers = 2, nstart = 25)
k3 <- kmeans(dataku, centers = 3, nstart = 25)
k4 <- kmeans(dataku, centers = 4, nstart = 25)
k5 <- kmeans(dataku, centers = 5, nstart = 25)

# plots to compare
p1 <- fviz_cluster(k2, geom = "point", data = dataku) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point",  data = dataku) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point",  data = dataku) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point",  data = dataku) + ggtitle("k = 5")

grid.arrange(p1, p2, p3, p4, nrow = 2)

par(mfrow = c(1, 1))
#PROSES MEMBUAT SPIDER CHART

#membuat cluster plot
# Buat list baru untuk menyimpan hasil perubahan
k3 <- k3

# Ubah nilai dalam k3$cluster sesuai dengan ketentuan yang Anda sebutkan
k3$cluster <- ifelse(k3$cluster == 1, 2, ifelse(k3$cluster == 2, 3, 1))

# Cek hasil perubahan
str(k3)


datafinal = data.frame(df, k3$cluster)
str(k3)
#Nilai rata-rata untuk masing masing cluster
data_radar =  dataku%>% mutate(cluster = k3$cluster) %>%
  group_by(cluster) %>% summarise_all("mean")

data_radar$IKL_2022mean

# MEMBUAT RADAR CHART ATAU SPIDER CHART

# MENYIAPKAN DATA
radar_fmsb = data_frame(datafinal$k3.cluster, datafinal[,17:25])
radar_fmsb$`datafinal$k3.cluster` = as.factor(radar_fmsb$`datafinal$k3.cluster`)
colnames(radar_fmsb)
colnames(radar_fmsb) = c("cluster", "AOD_2022mean", "NO2_2022mean", "CO_2022mean", "SO2_2022mean", "NDVI_2022mean", "NTL_2022mean","LST_2022mean", "TSS_2022mean", "IKL_2022mean")
radar_fmsb$cluster = as.character(radar_fmsb$cluster)

max_min <- data.frame(
  AOD_2022mean = c(max(radar_fmsb$AOD_2022mean), min(radar_fmsb$AOD_2022mean)), 
  NO2_2022mean = c(max(radar_fmsb$NO2_2022mean), min(radar_fmsb$NO2_2022mean)),
  CO_2022mean = c(max(radar_fmsb$CO_2022mean), min(radar_fmsb$CO_2022mean)), 
  SO2_2022mean = c(max(radar_fmsb$SO2_2022mean), min(radar_fmsb$SO2_2022mean)), 
  NDVI_2022mean = c(max(radar_fmsb$NDVI_2022mean), min(radar_fmsb$NDVI_2022mean)),
  NTL_2022mean = c(max(radar_fmsb$NTL_2022mean), min(radar_fmsb$NTL_2022mean)), 
  LST_2022mean = c(max(radar_fmsb$LST_2022mean), min(radar_fmsb$LST_2022mean)), 
  TSS_2022mean = c(max(radar_fmsb$TSS_2022mean), min(radar_fmsb$TSS_2022mean)),
  IKL_2022mean = c(max(radar_fmsb$IKL_2022mean), min(radar_fmsb$IKL_2022mean))
)
data_radar$cluster = NULL
rownames(max_min) <- c("Max", "Min")
data_radar_fmsb <- rbind(max_min, data_radar)
data_radar_fmsb


create_beautiful_radarchart <- function(data, color = "#00AFBB", 
                                        vlabels = colnames(data), vlcex = 0.7,
                                        caxislabels = NULL, title = NULL, ...){
  radarchart(
    data, axistype = 1,
    # Customize the polygon
    pcol = color, pfcol = scales::alpha(color, 0.5), plwd = 2, plty = 1,
    # Customize the grid
    cglcol = "grey", cglty = 1, cglwd = 0.8,
    # Customize the axis
    axislabcol = "grey", 
    # Variable labels
    vlcex = vlcex, vlabels = vlabels,
    caxislabels = caxislabels, title = title, ...
  )
}


#CHART UNTUK SEMUA CLASTER

# SPIDERCHART UNTUK MASING MASING VARIABEL
colors <- c("#00AFBB", "#E7B800", "#FC4E07")
titles <- c("Cluster 1", "Cluster 2", "Cluster 3")

# Reduce plot margin using par()
# Split the screen in 3 parts
op <- par(mar = c(1, 1, 1, 1))
par(mfrow = c(1,3))

# Create the radar chart
for(i in 1:3){
  create_beautiful_radarchart(
    data = data_radar_fmsb[c(1, 2, i+2), ], caxislabels=c("Min", "", "", "", "Max"),
    color = colors[i], title = titles[i]
  )
}
par(op)
par(mfrow = c(1, 1))


#PERBANDINGAN ANTAR VARIABEL UNTUK MASING MASING VARIABEL
op <- par(mar = c(1, 2, 2, 2))
create_beautiful_radarchart(
  data = data_radar_fmsb,caxislabels=c("Min", "", "", "", "Max"),
  color = c("#00AFBB", "#E7B800", "#FC4E07")
)
legend(
  x = "bottom", legend = rownames(data_radar_fmsb[-c(1,2),]), horiz = TRUE,
  bty = "n", pch = 20 , col = c("#00AFBB", "#E7B800", "#FC4E07"),
  text.col = "black", cex = 1, pt.cex = 1.5
)
par(op)
#c("#FC4E07", "#E7B800", "#00AFBB")
par(mfrow = c(1, 1))


#Membuat peta hasil cluster
setwd("D:/2024/Datathon/Data/Sumber Peta")

#INPUT PETA DESA
petajabar = read_sf(dsn = "jabar_desa.shp")
print(petajabar)
colnames(petajabar)
petajabar1 <- subset(petajabar, select = c("NAME_1", "NAME_2", "NAME_3", "NAME_4", "CC_4", "geometry"))
petajabar1$cluster = datafinal$k3.cluster

# Konversi kolom cluster menjadi faktor
petajabar1$cluster <- factor(petajabar1$cluster)

# Tetapkan warna untuk setiap cluster
warna_cluster <- c("1" = "#00AFBB", "2" = "#E7B800", "3" = "#FC4E07")
#remotes::install_github('r-tmap/tmap')
plotjabar = ggplot() +  
  geom_sf(data = petajabar1, aes(fill = cluster)) + 
  scale_fill_manual(values = warna_cluster) +
  ggtitle("Peta Jawa Barat") + theme_minimal()

plotjabar


#MENAMBAHKAN BASEMAP PADA PETA
tmap_mode("view")
tmap_last()
tmap_options(check.and.fix = TRUE)
tm_shape(petajabar1) + tm_polygons("cluster", palette=warna_cluster, alpha = .4, id = "NAME_3")


#EXPORT DATA
setwd("D:/2024/Datathon/Pengolahan Data/IKL 2022/Visualisasi Hasil Analisis/")
write.csv2(datafinal, "datafinal.csv", row.names=FALSE)

petajabar = data.frame(petajabar, datafinal[,17:26])
st_write(petajabar, "jabar2022final.shp")
