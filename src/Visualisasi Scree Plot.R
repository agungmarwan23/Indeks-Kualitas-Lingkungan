library(ggplot2)
library(gridExtra)
library(ggpubr)

### MEMBUAT DATA
dt21 <- data.frame(
  Komponen = c("1",
               "2",
               "3",
               "4",
               "5",
               "6",
               "7",
               "8"),
  Variance = c(
    66.74, 12.28, 7.57, 6.06, 4.07, 1.75, 1.46, 0.08
  )
)

dt22 <- data.frame(
  Komponen = c("1",
               "2",
               "3",
               "4",
               "5",
               "6",
               "7",
               "8"),
  Variance = c(
    68.89, 11.61, 6.78, 5.40, 3.35, 2.06, 1.76, 0.16
  )
)

dt23 <- data.frame(
  Komponen = c("1",
               "2",
               "3",
               "4",
               "5",
               "6",
               "7",
               "8"),
  Variance = c(
    64.15, 12.63, 8.77, 6.10, 4.86, 1.88, 1.46, 0.16
  )
)

### VISUALISASI
scree21 <- ggplot(data = dt21, aes(x = Komponen, y = Variance))+
  geom_point(size = 2, color = "blue")+
  geom_line(aes(group = 1), size = 1)+
  labs(title = "Scree Plot 2021",
       x = "Component",
       y = "Variance Explained (%)")+
  theme_minimal()+
  theme(
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    plot.title = element_text(hjust = 0.5)
  )
scree21


scree22 <- ggplot(data = dt22, aes(x = Komponen, y = Variance))+
  geom_point(size = 2, color = "blue")+
  geom_line(aes(group = 1), size = 1)+
  labs(title = "Scree Plot 2022",
       x = "Component",
       y = "Variance Explained (%)")+
  theme_minimal()+
  theme(
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    plot.title = element_text(hjust = 0.5)
  )
scree22


scree23 <- ggplot(data = dt23, aes(x = Komponen, y = Variance))+
  geom_point(size = 2, color = "blue")+
  geom_line(aes(group = 1), size = 1)+
  labs(title = "Scree Plot 2023",
       x = "Component",
       y = "Variance Explained (%)")+
  theme_minimal()+
  theme(
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    plot.title = element_text(hjust = 0.5)
  )
scree23

ggarrange(scree21, scree22, ncol = 2)
