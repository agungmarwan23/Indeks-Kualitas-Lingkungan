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
library(RStoolbox)
library(raster)
library(sp)
library(factoextra)
library(tictoc)
library(RColorBrewer)
library(tmap)
library(maps)
library(leaflet)
library(BAMMtools)
setwd("D:/2024/Datathon/Pengolahan Data/IKL 2021/")


df <- read_csv("Data_Merge_2021.csv")
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


#MEMBUAT KLASIFIKASI DENGAN METODE NATURAL BREAKS CLASSIFICATION
# Data IKL 2021mean
IKL_data <- df$IKL_2021mean

# Batas klasifikasi yang telah ditentukan
breaks <- c(-1, -0.17268660, -0.02916838, 0.11538328, 0.31287079, 1)
# Klasifikasi
classified_IKL <- cut(IKL_data, breaks, labels = FALSE)

# Mengganti nilai-nilai klasifikasi dengan label kelas
classified_IKL[classified_IKL == 1] <- 1
classified_IKL[classified_IKL == 2] <- 2
classified_IKL[classified_IKL == 3] <- 3
classified_IKL[classified_IKL == 4] <- 4
classified_IKL[classified_IKL == 5] <- 5

# Menambahkan klasifikasi ke dalam DataFrame
df$Klasifikasi <- classified_IKL

#########################################
#Nilai rata-rata untuk masing masing cluster
data_radar =  dataku%>% mutate(cluster = df$Klasifikasi) %>%
  group_by(cluster) %>% summarise_all("mean")

data_radar

# MEMBUAT RADAR CHART ATAU SPIDER CHART

# MENYIAPKAN DATA
radar_fmsb = data_frame(df$Klasifikasi, df[,17:25])
radar_fmsb$`df$Klasifikasi` = as.factor(radar_fmsb$`df$Klasifikasi`)
colnames(radar_fmsb)
colnames(radar_fmsb) = c("cluster", "AOD_2021mean", "NO2_2021mean", "CO_2021mean", "SO2_2021mean", "NDVI_2021mean", "NTL_2021mean","LST_2021mean", "TSS_2021mean", "IKL_2021mean")
radar_fmsb$cluster = as.character(radar_fmsb$cluster)

max_min <- data.frame(
  AOD_2021mean = c(max(radar_fmsb$AOD_2021mean), min(radar_fmsb$AOD_2021mean)), 
  NO2_2021mean = c(max(radar_fmsb$NO2_2021mean), min(radar_fmsb$NO2_2021mean)),
  CO_2021mean = c(max(radar_fmsb$CO_2021mean), min(radar_fmsb$CO_2021mean)), 
  SO2_2021mean = c(max(radar_fmsb$SO2_2021mean), min(radar_fmsb$SO2_2021mean)), 
  NDVI_2021mean = c(max(radar_fmsb$NDVI_2021mean), min(radar_fmsb$NDVI_2021mean)),
  NTL_2021mean = c(max(radar_fmsb$NTL_2021mean), min(radar_fmsb$NTL_2021mean)), 
  LST_2021mean = c(max(radar_fmsb$LST_2021mean), min(radar_fmsb$LST_2021mean)), 
  TSS_2021mean = c(max(radar_fmsb$TSS_2021mean), min(radar_fmsb$TSS_2021mean)),
  IKL_2021mean = c(max(radar_fmsb$IKL_2021mean), min(radar_fmsb$IKL_2021mean))
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
colors <- c("#45ff00", "#91de00", "#ddd600", "#f16200", "#fc0000")
titles <- c("Klasifikasi 1", "Klasifikasi 2", "Klasifikasi 3", "Klasifikasi 4", "Klasifikasi 5")

# Reduce plot margin using par()
# Split the screen in 3 parts
op <- par(mar = c(1, 1, 1, 1))
par(mfrow = c(2,3))

# Create the radar chart
for(i in 1:5){
  create_beautiful_radarchart(
    data = data_radar_fmsb[c(1, 2, i+2), ], caxislabels=c("Min", "", "", "","","", "Max"),
    color = colors[i], title = titles[i]
  )
}
par(op)
par(mfrow = c(1, 1))


#PERBANDINGAN ANTAR VARIABEL UNTUK MASING MASING VARIABEL
op <- par(mar = c(1, 2, 2, 2))
create_beautiful_radarchart(
  data = data_radar_fmsb,caxislabels=c("Min", "", "", "", "Max"),
  color = c("#45ff00", "#91de00", "#ddd600", "#f16200", "#fc0000")
)
legend(
  x = "bottom", legend = rownames(data_radar_fmsb[-c(1,2),]), horiz = TRUE,
  bty = "n", pch = 20 , col = c("#45ff00", "#91de00", "#ddd600", "#f16200", "#fc0000"),
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
petajabar1$cluster = df$Klasifikasi

# Konversi kolom cluster menjadi faktor
petajabar1$cluster <- factor(petajabar1$cluster)
petajabar1
# Tetapkan warna untuk setiap cluster
warna_cluster <- c("1" = "#45ff00", "2" = "#91de00", "3" = "#ddd600", "4" = "#f16200", "5" = "#fc0000")
#remotes::install_github('r-tmap/tmap')
plotjabar = ggplot() +  
  geom_sf(data = petajabar1, aes(fill = cluster)) + 
  scale_fill_manual(values = warna_cluster) +
  ggtitle("Peta Jawa Barat") + theme_minimal()

plotjabar

library(tmap)
petajabar1$ILK_2021mean = df$IKL_2021mean
# Konversi petajabar1 menjadi objek tmap
petajabar_tmap <- tm_shape(petajabar1) +
  tm_fill("ILK_2021mean", title = "IKL", 
          breaks = c(-0.48, -0.176, -0.031,  0.115, 0.313, 0.609),
          palette = warna_cluster) +
  tm_borders(col = "black") +  # Tambahkan batas-batas wilayah
  tm_layout("IKL 2021",
            legend.title.size = 1,
            legend.position = c("right", "top"),  # Tentukan posisi legenda
            legend.bg.color = "white",  # Warna latar belakang legenda
            legend.bg.alpha = 0.7)  # Opasitas latar belakang legenda

# Tambahkan lambang arah mata angin
petajabar_tmap <- petajabar_tmap + tm_compass(position = c("left", "top"))

# Tambahkan skala peta
petajabar_tmap <- petajabar_tmap + tm_scale_bar(position = c("right", "bottom"))

# Menyimpan plot sebagai file PNG dengan resolusi 600 DPI
tmap_save(petajabar_tmap, filename = "D:/2024/Datathon/Pengolahan Data/IKL 2021/Visualisasi Hasil Analisis/IKL_2021.png", dpi = 600)





#SAVE DATA PETA SETELAH DITAMBAHKAN FILE
st_write(petajabar1, "D:/2024/Datathon/Pengolahan Data/IKL 2021/Visualisasi Hasil Analisis/jabar2021final.shp")
