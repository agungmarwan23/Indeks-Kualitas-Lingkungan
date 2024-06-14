library(readr)
IKL_Kab_2023 <- read_csv("C:/Users/BPS-14036/Downloads/ZonStat_IKL_Kab_2023.csv", 
                           col_types = cols(IDKAB = col_character(), 
                           TAHUN = col_character()))

IKL_Kab_2022 <- read_csv("C:/Users/BPS-14036/Downloads/ZonStat_IKL_Kab_2022.csv", 
                         col_types = cols(IDKAB = col_character(), 
                                          TAHUN = col_character()))

IKL_Kab_2021 <- read_csv("C:/Users/BPS-14036/Downloads/ZonStat_IKL_Kab_2021.csv", 
                         col_types = cols(IDKAB = col_character(), 
                                          TAHUN = col_character()))

IKL_Kab = data.frame(IKL_Kab_2021, IKL_Kab_2022$IKL2022mean, IKL_Kab_2023$IKL2023mean)
colnames(IKL_Kab) = c("PROVNO", "KABKOTNO", "PROVINSI","KABKOT", "IDKAB", "TAHUN", "SUMBER", "IKL2021mean", "IKL2022mean", "IKL2023mean")
setwd("C:/Users/BPS-14036/Downloads/")
write.csv2(IKL_Kab, "IKL_Kab.csv")


df <- read.delim("clipboard")
IKL_data = df$IKL2023mean
breaks <- c(-1, -0.17268660, -0.02916838, 0.11538328, 0.31287079, 1)
# Klasifikasi
classified_IKL <- cut(IKL_data, breaks, labels = FALSE)

# Mengganti nilai-nilai klasifikasi dengan label kelas
classified_IKL[classified_IKL == 1] <- "1. Sangat Baik"
classified_IKL[classified_IKL == 2] <- "2. Baik"
classified_IKL[classified_IKL == 3] <- "3. Sedang"
classified_IKL[classified_IKL == 4] <- "4. Cukup"
classified_IKL[classified_IKL == 5] <- "5. Buruk"

# Menambahkan klasifikasi ke dalam DataFrame
df$Klasifikasi_2023 <- classified_IKL

write.table(df, "clipboard", sep="\t", row.names=FALSE, col.names=TRUE)

#########################################
#Nilai rata-rata untuk masing masing cluster

data_radar



#membuat barchart untuk ikl antar tahun
setwd("D:/2024/Datathon/Pengolahan Data/Dashboard/Barchart")
df <- read.delim("clipboard")
#tahun 2021
library(ggplot2)

# Ubah format angka yang dipisahkan dengan koma menjadi desimal
df$IKL2021mean <- as.numeric(gsub(",", ".", df$IKL2021mean))

# Urutkan data berdasarkan kolom IKL2021mean secara menurun
df <- df[order(-df$IKL2021mean), ]

# Beri warna berdasarkan spesifikasi yang Anda tentukan
df$color <- ifelse(df$KABKOT == "KOTA BANDUNG", "#E7B800",
                   ifelse(df$KABKOT == df$KABKOT[1], "#FC4E07",
                  ifelse(df$KABKOT == df$KABKOT[27], "#00AFBB","grey")))

# Buat barchart
ggplot(df, aes(x = reorder(KABKOT, -IKL2021mean), y = IKL2021mean, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  labs(x = "KABKOT", y = "IKL2021mean") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p = NULL
p <- ggplot(df, aes(x = reorder(KABKOT, -IKL2021mean), y = IKL2021mean, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  labs(x = "KABKOT", y = "IKL2021mean") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Tambahkan nilai IKL2021mean di atas barchart untuk Kota Bandung
p <- p +
  geom_text(data = subset(df, KABKOT == "KOTA BANDUNG" | KABKOT == df$KABKOT[27] | KABKOT == df$KABKOT[1]), 
            aes(label = sprintf("%.3f", IKL2021mean)), 
            vjust = -0.5, color = "black")


#TAHUN 2022
library(ggplot2)

# Ubah format angka yang dipisahkan dengan koma menjadi desimal
df$IKL2022mean <- as.numeric(gsub(",", ".", df$IKL2022mean))

# Urutkan data berdasarkan kolom IKL2021mean secara menurun
df <- df[order(-df$IKL2022mean), ]

# Beri warna berdasarkan spesifikasi yang Anda tentukan
df$color <- ifelse(df$KABKOT == "KOTA BANDUNG", "#E7B800",
                   ifelse(df$KABKOT == df$KABKOT[1], "#FC4E07",
                          ifelse(df$KABKOT == df$KABKOT[27], "#00AFBB","grey")))

# Buat barchart
ggplot(df, aes(x = reorder(KABKOT, -IKL2022mean), y = IKL2022mean, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  labs(x = "KABKOT", y = "IKL2022mean") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p = NULL
p <- ggplot(df, aes(x = reorder(KABKOT, -IKL2022mean), y = IKL2022mean, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  labs(x = "KABKOT", y = "IKL2022mean") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Tambahkan nilai IKL2021mean di atas barchart untuk Kota Bandung
p <- p +
  geom_text(data = subset(df, KABKOT == "KOTA BANDUNG" | KABKOT == df$KABKOT[27] | KABKOT == df$KABKOT[1]), 
            aes(label = sprintf("%.3f", IKL2022mean)), 
            vjust = -0.5, color = "black")


p


#TAHUN 2023
library(ggplot2)

# Ubah format angka yang dipisahkan dengan koma menjadi desimal
df$IKL2023mean <- as.numeric(gsub(",", ".", df$IKL2023mean))

# Urutkan data berdasarkan kolom IKL2021mean secara menurun
df <- df[order(-df$IKL2023mean), ]

# Beri warna berdasarkan spesifikasi yang Anda tentukan
df$color <- ifelse(df$KABKOT == "KOTA BANDUNG", "#E7B800",
                   ifelse(df$KABKOT == df$KABKOT[1], "#FC4E07",
                          ifelse(df$KABKOT == df$KABKOT[27], "#00AFBB","grey")))

# Buat barchart
ggplot(df, aes(x = reorder(KABKOT, -IKL2023mean), y = IKL2023mean, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  labs(x = "KABKOT", y = "IKL2023mean") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p = NULL
p <- ggplot(df, aes(x = reorder(KABKOT, -IKL2023mean), y = IKL2023mean, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  labs(x = "KABKOT", y = "IKL2023mean") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Tambahkan nilai IKL2021mean di atas barchart untuk Kota Bandung
p <- p +
  geom_text(data = subset(df, KABKOT == "KOTA BANDUNG" | KABKOT == df$KABKOT[27] | KABKOT == df$KABKOT[1]), 
            aes(label = sprintf("%.3f", IKL2023mean)), 
            vjust = -0.5, color = "black")



######################################
# Install and load the required packages
install.packages("ggplot2")
install.packages("dplyr")
install.packages("reshape2")
library(ggplot2)
library(dplyr)
library(reshape2)

# Create the data frame
df <- data.frame(
  KABKOT = c("BOGOR", "SUKABUMI", "CIANJUR", "BANDUNG", "GARUT", "TASIKMALAYA", "CIAMIS", "KUNINGAN", 
             "CIREBON", "MAJALENGKA", "SUMEDANG", "INDRAMAYU", "SUBANG", "PURWAKARTA", "KARAWANG", 
             "BEKASI", "BANDUNG BARAT", "PANGANDARAN", "KOTA BOGOR", "KOTA SUKABUMI", "KOTA BANDUNG", 
             "KOTA CIREBON", "KOTA BEKASI", "KOTA DEPOK", "KOTA CIMAHI", "KOTA TASIKMALAYA", "KOTA BANJAR", 
             "WADUK CIRATA"),
  IKL_2021 = c(0.1314989738, -0.07538195138, -0.08099018652, -0.207184339, -0.2112817956, -0.1501606356, 
                  -0.07750106785, -0.05481305361, 0.1613079801, 0.03134146947, -0.06210600078, 0.1696454645, 
                  0.1093184227, 0.1095631366, 0.2557648634, 0.3604302772, -0.05059780437, -0.06057950779, 
                  0.3275972079, 0.03023965151, 0.1228978607, 0.2210029744, 0.5430427799, 0.5011764565, 
                  0.1595207652, -0.02692344116, 0.07336834866, 0.1681662643),
  IKL_2022 = c(0.0935356093, -0.09607559699, -0.08513386283, -0.1871319564, -0.2151485907, -0.1588728653, 
                  -0.08799966233, -0.0683020006, 0.194337218, 0.03736935702, -0.06029935849, 0.2236682351, 
                  0.123651942, 0.09757526207, 0.2820200143, 0.3736518701, -0.06858015622, -0.06448816779, 
                  0.2700908449, 0.04232691138, 0.1880136398, 0.2497557216, 0.529588413, 0.4293105686, 
                  0.1772607878, -0.01195675172, 0.04736592156, 0.2249747732)
)

# Melt the data frame for ggplot2
df_melted <- melt(df, id.vars = "KABKOT", variable.name = "Year", value.name = "IKLmean")

# Sort the data frame within each year
df_melted <- df_melted %>%
  group_by(Year) %>%
  arrange(desc(IKLmean), .by_group = TRUE) %>%
  ungroup()

# Define the color conditions
df_melted$Color <- ifelse(df_melted$KABKOT == "KOTA BANDUNG", "#E7B800",
                          ifelse(df_melted$KABKOT == "KOTA BEKASI", "#FC4E07",
                                 ifelse(df_melted$KABKOT == "GARUT", "#00AFBB","grey")))

# Create the barchart
ggplot(df_melted, aes(x = reorder(KABKOT, -IKLmean), y = IKLmean, fill = Color)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Year, ncol = 2, scales = "free_x") +
  scale_fill_identity() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "", x = "Kabupaten/Kota", y = "IKL") +
  theme(strip.text = element_text(size = 10),
        plot.title = element_text(hjust = 0.5, size = 20))
