library(readxl)
library(googlesheets4)
library(writexl)

dt <- read_xlsx("Kaitan IKL Vs Data Open Data Jabar (1).xlsx")
cor <- cor(dt[,c(8:18)])
cor <- as.data.frame(cor)

write_xlsx(cor, "Hasil Uji Performa IKL.xlsx")

# IKL 2021 VS IKLH 2021
cor.test(dt$IKL2021mean, dt$IKLH_2021)
# IKL 2021 VS IKES 2021
cor.test(dt$IKL2021mean, dt$IKes_2021)
# IKL 2021 VS KEPADATAN PENDUDUK
cor.test(dt$IKL2021mean, dt$kepadatan_pddk_2021)

# IKL 2022 VS IKLH 2022
cor.test(dt$IKL2022mean, dt$IKLH_2022)
# IKL 2022 VS IKES 2022
cor.test(dt$IKL2022mean, dt$IKes_2022)
# IKL 2022 VS KEPADATAN PENDUDUK 2022
cor.test(dt$IKL2022mean, dt$kepadatan_pddk_2022)

# IKL 2023 VS IKLH 2023
cor.test(dt$IKL2023mean, dt$IKLH_2023)
# IKL 2023 VS IKES 2023 (DATA 2023 IKES TIDAK TERSEDIA)
# IKL 2023 VS KEPADATAN PENDUDUK 2023
cor.test(dt$IKL2023mean, dt$kepadatan_pddk_2023)
