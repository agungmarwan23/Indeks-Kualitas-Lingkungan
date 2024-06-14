### LIBRARY YANG DIGUNAKAN
library(RStoolbox)
library(raster)
library(sp)
library(factoextra)
library(tictoc)
library(RColorBrewer)

### IMPORT DATA
aod22 <- raster("AOD_2022.tif")
co22 <- raster("CO_2022.tif")
lst22 <- raster("LST_2022.tif")
ndvi22 <- raster("NDVI_2022.tif")
no222 <- raster("NO2_2022.tif")
ntl22 <- raster("NTL_2022.tif")
so222 <- raster("SO2_2022.tif")
tss22 <- raster("Sentinel_2022_TSS.tif")

### PENYESUAIAN DATA
convert_unit <- function(dt){
  dt <- (dt*6.02*10^(23))/10000
  return(dt)
}

no222 <- convert_unit(no222)
writeRaster(no222, "NO2_TERKONVERSI_2022.tif")
co22 <- convert_unit(co22)
writeRaster(co22, "CO_TERKONVERSI_2022.tif")
so222 <- convert_unit(so222)
writeRaster(so222, "SO2_TERKONVERSI_2022.tif")

convert_lst <- function(dat) {
  dat <- (dat*0.02)-273.15
  return(dat)
}

lst22 <- convert_lst(lst22)
writeRaster(lst22, "LST_TERKONVERSI_2022.tif")

lst22 <- resample(lst22, ndvi22)

crs(lst22) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(co22) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(lst22) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(no222) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(so222) <- "+proj=longlat +datum=WGS84 +no_defs"

rasterdt22 <- brick(aod22, no222, co22, so222,
                    ndvi22,
                    ntl22, lst22, tss22)

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
    rasterdt22[[i]] <- normalizepos(rasterdt22[[i]])
  } else if (i == 5) {
    rasterdt22[[i]] <- normalizeneg(rasterdt22[[i]])
  } else {
    rasterdt22[[i]] <- normalizepos(rasterdt22[[i]])
  }
}

writeRaster(rasterdt22, "data_raster_2022.tif")

### SPCA
SPCA22 <- rasterPCA(rasterdt22, nComp = 8, nSamples = 100000)
plot(SPCA22$map)

eigenv22 <- get_eigenvalue(SPCA22$model)
eigenv22

ggplot(data = eigenv22,
       aes(x = c("Dim.1", "Dim.2", "Dim.3", "Dim.4", "Dim.5", "Dim.6", "Dim.7", "Dim.8"),
           y = variance.percent))+
  geom_col() + 
  geom_point(size=4)+
  xlab("Principal Component") + 
  ylab("Variance Explained") +
  ggtitle("Scree Plot")

jmleigv22 <- sum(eigenv22$eigenvalue[1:3])
w1 <- eigenv22$eigenvalue[1]/jmleigv22
w2 <- eigenv22$eigenvalue[2]/jmleigv22
w3 <- eigenv22$eigenvalue[3]/jmleigv22
weigh <- c(w1, w2, w3)
weigh

ikl22_ar <- w1*SPCA22$map$PC1 + w2*SPCA22$map$PC2 + w3*SPCA22$map$PC3
plot(ikl22_ar)
writeRaster(ikl22_ar, "ikl22.tif")

var <- get_pca_var(SPCA22$model)
sum(var$contrib[,1])
cjk <- var$contrib
cjk <- as.data.frame(cjk)

eigmat <- as.matrix(eigenv22$eigenvalue)
t(eigmat)

cij <- as.matrix(cjk)
t(cij)

cj <- t(eigmat)%*%t(cij)
cj

kontrib <- (cj/sum(eigenv22$eigenvalue))
kontrib
t(kontrib)
