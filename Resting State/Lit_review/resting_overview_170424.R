# Require packages
require(RColorBrewer)

# Define colors for plotting
cols <- brewer.pal(9, "Set1")
cols <- c(cols, "black")

# Read data; sort and process
data_for_barplot <- read.csv2("Resting State/Lit_review/data_for_barplot.csv")
names(data_for_barplot)[1] <- "name"
data_for_barplot <- data_for_barplot[order(data_for_barplot$n.analysed, decreasing = T), ]
data_for_barplot$constellation <- c("Singapore", "Oslo", "Stockholm", "Chongqing", "Munich", "Xi'an", "Singapore", "Chongqing", "Beijing", "Tel Aviv", "Nanchang", "Munich", "Beijing", "Zurich", "Nanchang")
data_for_barplot$location <- c("Singapore 2", "Oslo", "Stockholm", "Chongqing 2", "Munich 2", "Xi'an", "Singapore 1", "Chongqing 1", "Beijing 2", "Tel Aviv", "Nanchang 1", "Munich 1", "Beijing 1", "Zurich", "Nanchang 2")

# Make plots
par(mar=c(5,8,2,2))
barplot(data_for_barplot$n.analysed, names.arg = data_for_barplot$name, horiz = T, xlim = c(0, 70), las = 1, main = "Sample sizes", xlab = "n")
barplot(data_for_barplot$n.analysed, names.arg = data_for_barplot$location, horiz = T, xlim = c(0, 70), col = cols[c(1, 2, 3, 4, 5, 6, 1, 4, 7, 10, 8, 5, 7, 9, 8)], las = 1, main = "Sample sizes by location", xlab = "n")
