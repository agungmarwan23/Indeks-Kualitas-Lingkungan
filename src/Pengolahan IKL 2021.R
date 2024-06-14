### LIBRARY YANG DIGUNAKAN
library(RStoolbox)
library(raster)
library(sp)
library(factoextra)
library(tictoc)
library(RColorBrewer)

### IMPORT DATA
aod21 <- raster("AOD_2021.tif")
co21 <- raster("CO_2021.tif")
lst21 <- raster("LST_2021.tif")
ndvi21 <- raster("NDVI_2021.tif")
no221 <- raster("NO2_2021.tif")
ntl21 <- raster("NTL_2021.tif")
so221 <- raster("SO2_2021.tif")
tss21 <- raster("Sentinel_2021_TSS.tif")

### PENYESUAIAN DATA
convert_unit <- function(dt){
  dt <- (dt*6.02*10^(23))/10000
  return(dt)
}

no221 <- convert_unit(no221)
writeRaster(no221, "NO2_TERKONVERSI_2021.tif")
co21 <- convert_unit(co21)
writeRaster(co21, "CO_TERKONVERSI_2021.tif")
so221 <- convert_unit(so221)
writeRaster(so221, "SO2_TERKONVERSI_2021.tif")

convert_lst <- function(dat) {
  dat <- (dat*0.02)-273.15
  return(dat)
}

lst21 <- convert_lst(lst21)
writeRaster(lst21, "LST_TERKONVERSI.tif")

lst21 <- resample(lst21, ndvi21)

crs(lst21) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(so221) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(co21) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(no221) <- "+proj=longlat +datum=WGS84 +no_defs"

rasterdt21 <- brick(aod21, no221, co21, so221,
                    ndvi21,
                    ntl21, lst21, tss21)

normalizepos <- function(x){
  x <- (x-minValue(x))/(maxValue(x)-minValue(x))
  return(x)
}


normalizeneg <- function(y) {
  y <- 1-((y-minValue(y))/(maxValue(y)-minValue(y)))
  return(y)
}

for (i in 1:8) {
  if (i < 5) {
    rasterdt21[[i]] <- normalizepos(rasterdt21[[i]])
  } else if (i == 5) {
    rasterdt21[[i]] <- normalizeneg(rasterdt21[[i]])
  } else {
    rasterdt21[[i]] <- normalizepos(rasterdt21[[i]])
  }
}

### SPCA
SPCA21 <- rasterPCA(rasterdt21, nComp = 8)
plot(SPCA21$map)

eigenv21 <- get_eigenvalue(SPCA21$model)
eigenv21

ggplot(data = eigenv21,
       aes(x = c("Dim.1", "Dim.2", "Dim.3", "Dim.4", "Dim.5", "Dim.6", "Dim.7", "Dim.8"),
           y = variance.percent))+
  geom_col() + 
  geom_point(size=4)+
  xlab("Principal Component") + 
  ylab("Variance Explained") +
  ggtitle("Scree Plot")

jmleigv21 <- sum(eigenv21$eigenvalue[1:3])
w1 <- eigenv21$eigenvalue[1]/jmleigv21
w2 <- eigenv21$eigenvalue[2]/jmleigv21
w3 <- eigenv21$eigenvalue[3]/jmleigv21
weigh <- c(w1, w2, w3)
weigh

ikl21_ar <- w1*SPCA21$map$PC1 + w2*SPCA21$map$PC2 + w3*SPCA21$map$PC3
plot(ikl21_ar)
writeRaster(ikl21_ar, "ikl21.tif", overwrite = T)

var <- get_pca_var(SPCA21$model)
sum(var$contrib[,1])
cjk <- var$contrib
cjk <- as.data.frame(cjk)

eigmat <- as.matrix(eigenv21$eigenvalue[1:3])
t(eigmat)

cij <- as.matrix(cjk[,1:3])
t(cij)

cj <- t(eigmat)%*%t(cij)
cj

kontrib <- (cj/sum(eigenv21$eigenvalue[1:3]))
kontrib
t(kontrib)

dt <- data.frame(
  var = c("AOD", "NO2", "CO", "SO2", "NDVI", "NTL", "LST", "TSS"),
  kontrib = t(kontrib)
)
dt

dt$var <- factor(dt$var, levels = dt$var[order(dt$kontrib, decreasing = TRUE)])
ggplot(dt, aes(x = var, y = kontrib)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = sprintf("%.2f", kontrib)), vjust = -0.5, size = 4, color = "black") +  # Add text annotations for values
  labs(title = "Kontribusi Variabel Terhadap IKL 2021", x = "Variabel", y = "Kontribusi (%)")+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5),
        axis.title = element_text(size = 14, face = "bold.italic"))
