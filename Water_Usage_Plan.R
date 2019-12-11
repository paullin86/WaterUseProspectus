# https://data.gov.tw/dataset/58340
# https://data.wra.gov.tw/Service/OpenData.aspx?format=json&id=650FE486-C26D-4318-9EC6-C8DAF9907CB4
library(jsonlite)
Plan.url <- "https://data.wra.gov.tw/Service/OpenData.aspx?format=json&id=650FE486-C26D-4318-9EC6-C8DAF9907CB4"
temp <- fromJSON(Plan.url)
Plan.df <- as.data.frame(temp$AbstractOfWaterUsagePlan_OPENDATA)
colnames(Plan.df) <- c("PlanCode","PlanName","DevelopmentFactory","WaterRequired")
nrow(Plan.df)
write.csv(Plan.df,paste0("WaterUsagePlan_",nrow(Plan.df),".csv"),row.names = FALSE)

#-------------- HTML Table
# install.packages("DT")
library(DT)
datatable(Plan.df, 
          extensions = 'Responsive', options = list(
            deferRender = TRUE,
            scrollY = 800,
            scroller = TRUE,
            pageLength = 100,
            filter = 'top',
            searchHighlight = TRUE
          )) %>% formatRound("WaterRequired",1)
#-------------- 中水局資料
library(readr)
# install.packages("dplyr")
waterplan_central_150 <- read_csv("waterplan_150.csv", 
                          locale = locale(encoding = "BIG5"))
colnames(waterplan_central_150)
Plan.central.df<- dplyr::select(waterplan_central_150,Approved_date,tittle,applicant,CMD,Approved_info)
library(DT)
datatable(Plan.central.df, 
          extensions = 'Responsive', options = list(
            deferRender = TRUE,
            scrollY = 800,
            scroller = TRUE,
            pageLength = 100,
            filter = 'top',
            searchHighlight = TRUE
          )) 
# -----------------All_2019
waterplan_2019 <- read_csv("WaterUsagePlan_20191210.csv", 
                                  locale = locale(encoding = "BIG5"))
colnames(waterplan_2019)
# 將日期由民國年轉為西元年
waterplan_2019$核定日期 <- as.Date(unlist(lapply(waterplan_2019$核定日期, function(x) {
  if (nchar(x) == 8) return(paste0(as.numeric(substr(x,1,2))+1911, "-", substr(x,4,5), "-", substr(x,7,8)))
  if (nchar(x) == 9) return(paste0(as.numeric(substr(x,1,3))+1911, "-", substr(x,5,6), "-", substr(x,8,9)))
})))

library(DT)
y <- datatable(waterplan_2019, 
          extensions = 'Responsive', options = list(
            deferRender = TRUE,
            scrollY = 800,
            scroller = TRUE,
            pageLength = 100,
            filter = 'top',
            searchHighlight = TRUE
          )) 
DT::saveWidget(y, paste0("waterplan_2019",".html"))
