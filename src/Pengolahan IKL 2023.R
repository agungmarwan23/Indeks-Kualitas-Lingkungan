### LIBRARY YANG DIGUNAKAN
library(RStoolbox)
library(raster)
library(sp)
library(factoextra)
library(tictoc)
library(RColorBrewer)

### IMPORT DATA
aod23 <- raster("AOD_2023.tif")
co23 <- raster("CO_2023.tif")
lst23 <- raster("LST_2023.tif")
ndvi23 <- raster("NDVI_2023.tif")
no223 <- raster("NO2_2023.tif")
ntl23 <- raster("NTL_2023.tif")
so223 <- raster("SO2_2023.tif")
tss23 <- raster("Sentinel_2023_TSS.tif")

### PENYESUAIAN DATA
convert_unit <- function(dt){
  dt <- (dt*6.02*10^(23))/10000
  return(dt)
}

no223 <- convert_unit(no223)
writeRaster(no223, "NO2_TERKONVERSI_2023.tif")
co23 <- convert_unit(co23)
writeRaster(co23, "CO_TERKONVERSI_2023.tif")
so223 <- convert_unit(so223)
writeRaster(so223, "SO2_TERKONVERSI_2023.tif")

convert_lst <- function(dat) {
  dat <- (dat*0.02)-273.15
  return(dat)
}

lst23 <- convert_lst(lst23)
writeRaster(lst22, "LST_TERKONVERSI_2022.tif")

lst23 <- resample(lst23, ndvi23)

crs(so223) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(co23) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(lst23) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(no223) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(so223) <- "+proj=longlat +datum=WGS84 +no_defs"

rasterdt23 <- brick(aod23, no223, co23, so223,
                    ndvi23,
                    ntl23, lst23, tss23)

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
    rasterdt23[[i]] <- normalizepos(rasterdt23[[i]])
  } else if (i == 5) {
    rasterdt23[[i]] <- normalizeneg(rasterdt23[[i]])
  } else {
    rasterdt23[[i]] <- normalizepos(rasterdt23[[i]])
  }
}

writeRaster(rasterdt23, "data_raster_2023.tif")

### SPCA
SPCA23 <- rasterPCA(rasterdt23, nComp = 8, nSamples = 100000)
plot(SPCA23$map)

eigenv23 <- get_eigenvalue(SPCA23$model)
eigenv23

ggplot(data = eigenv23,
       aes(x = c("Dim.1", "Dim.2", "Dim.3", "Dim.4", "Dim.5", "Dim.6", "Dim.7", "Dim.8"),
           y = variance.percent))+
  geom_col() + 
  geom_point(size=4)+
  xlab("Principal Component") + 
  ylab("Variance Explained") +
  ggtitle("Scree Plot")

jmleigv23 <- sum(eigenv23$eigenvalue[1:3])
w1 <- eigenv23$eigenvalue[1]/jmleigv23
w2 <- eigenv23$eigenvalue[2]/jmleigv23
w3 <- eigenv23$eigenvalue[3]/jmleigv23
weigh <- c(w1, w2, w3)
weigh

ikl23_ar <- w1*SPCA23$map$PC1 + w2*SPCA23$map$PC2 + w3*SPCA23$map$PC3
plot(ikl23_ar)
writeRaster(ikl23_ar, "ikl23.tif")

var <- get_pca_var(SPCA23$model)
sum(var$contrib[,1])
cjk <- var$contrib
cjk <- as.data.frame(cjk)

eigmat <- as.matrix(eigenv23$eigenvalue[1:3])
t(eigmat)

cij <- as.matrix(cjk[,1:3])
t(cij)

cj <- t(eigmat)%*%t(cij)
cj

kontrib <- (cj/sum(eigenv23$eigenvalue[1:3]))
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
  labs(title = "Kontribusi Variabel Terhadap IKL 2023", x = "Variabel", y = "Kontribusi (%)")+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5),
        axis.title = element_text(size = 14, face = "bold.italic"))
