#Customer Retention Analysis

#Library
library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)

#Read Data
retail <- read_excel("Data/Online Retail.xlsx")

#General Feel of Data
head(retail)
str(retail)
summary(retail)

dim(retail)


#Missing Values
colSums(is.na(retail))
sum(is.na(retail$CustomerID))
sum(is.na(retail$Description))

round(colMeans(is.na(retail))* 100, 2)

#Invalid Transactions
sum(retail$Quantity < 0)
sum(retail$UnitPrice < 0)
sum(retail$UnitPrice == 0)

range(retail$InvoiceDate)

retail %>%
  filter(Quantity < 0) %>%
  count(InvoiceNo, sort = TRUE) %>%
  head(10)

retail %>%
  filter(Quantity < 0) %>%
  select(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID) %>%
  head(10)


#Data Cleaning
retail_clean <- retail %>%
  filter(
    !is.na(CustomerID),
    Quantity > 0,
    UnitPrice > 0
  )

nrow(retail)
nrow(retail_clean)

nrow(retail_clean)/nrow(retail) * 100

#Checking Data Cleaning
sum(is.na(retail_clean$CustomerID))
sum(retail_clean$Quantity < 0)
sum(retail_clean$UnitPrice <= 0)


#Create Revenue Variable
retail_clean <- retail_clean %>%
  mutate(
    Revenue = Quantity * UnitPrice
  )

#Export retail_clean to data folder
write.csv(
  retail_clean,
  "Data/retail_clean.csv",
  row.names = FALSE
)

#Initial Business Metrics
retail_clean %>%
  summarise(
    Transaction_Lines = n(),
    Unique_Transactions = n_distinct(InvoiceNo),
    Customers = n_distinct(CustomerID),
    Products = n_distinct(StockCode),
    Total_Revenue = sum(Revenue)
  )

retail_clean %>%
  count(Country, sort = TRUE)

TransactionRate <- 18532/4338

retail_clean %>%
  count(Country, sort = TRUE) %>%
  mutate(
    Percent = round(n / sum(n) * 100, 2)
  )

#Transaction per Customer
customer_summary <- retail_clean %>%
  group_by(CustomerID) %>%
  summarise(
    Transactions = n_distinct(InvoiceNo),
    Revenue = sum(Revenue)
  )

#Customer Behavior
summary(customer_summary$Transactions)
summary(customer_summary$Revenue)

customer_summary %>%
  summarise(
    One_Time = sum(Transactions == 1),
    Repeat = sum(Transactions > 1)
  )

customer_summary %>%
  summarise(
    One_Time_Pct = mean(Transactions == 1) * 100,
    Repeat_Pct = mean(Transactions > 1) * 100
  )

#Customer Retention Plot
ggplot(customer_summary,
       aes(x = Transactions)) +
  geom_histogram(binwidth = 1)

dispersionratio <- var(customer_summary$Transactions) / mean(customer_summary$Transactions)

#Top Generating Customers
customer_summary %>%
  arrange(desc(Revenue)) %>%
  head(10)

Top10_cutoff <- quantile(customer_summary$Revenue, .90)

customer_summary %>%
  summarise(
    Total_Revenue = sum(Revenue),
    Top10_Revenue = sum(Revenue[Revenue >= top10_cutoff]),
    Top10_Pct = Top10_Revenue / Total_Revenue * 100
  )

#Customer Segmentation
customer_summary %>%
  mutate(
    Customer_Type = case_when(
      Transactions == 1 ~ "One-Time",
      Transactions <= 5 ~ "Occasional",
      Transactions <= 20 ~ "Frequent",
      Transactions > 20 ~ "Highly Frequent"
    )
  ) %>%
  group_by(Customer_Type) %>%
  summarise(
    Customers = n(),
    Total_Revenue = sum(Revenue),
    Avg_Revenue = mean(Revenue),
    Median_Revenue = median(Revenue)
  ) %>%
  arrange(desc(Total_Revenue))

#Create Month Variable
retail_clean <- retail_clean %>%
  mutate(
    YearMonth = format(InvoiceDate, "%Y-%m")
  )

#Customer-Month Variable
customer_monthly <- retail_clean %>%
  distinct(CustomerID, YearMonth)

#Customer Cohort Variable
customer_cohort <- customer_monthly %>%
  group_by(CustomerID) %>%
  summarise(
    CohortMonth = min(YearMonth)
  )

head(customer_monthly)
head(customer_cohort)

customer_cohort %>%
  count(CohortMonth)

#Customer Retention Dataset
cohort_data <- customer_monthly %>%
  left_join(customer_cohort,
            by = "CustomerID")

cohort_data <- cohort_data %>%
  mutate(
    CohortDate = ym(CohortMonth),
    ActivityDate = ym(YearMonth),
    CohortIndex =
      interval(CohortDate, ActivityDate) %/% months(1)
  )

head(cohort_data, 20)
table(cohort_data$CohortIndex)

#Retention Frequency
retention_counts <- cohort_data %>%
  group_by(CohortMonth, CohortIndex) %>%
  summarise(
    Customers = n_distinct(CustomerID),
    .groups = "drop"
  )

head(retention_counts, 20)

#Adding Retention Rate
retention_counts <- retention_counts %>%
  group_by(CohortMonth) %>%
  mutate(
    RetentionRate = Customers / Customers[CohortIndex == 0] * 100
  )

head(retention_counts, 20)

#Cohort Retention Heatmap
ggplot(retention_counts,
       aes(x = CohortIndex,
           y = CohortMonth,
           fill = RetentionRate)) +
  geom_tile() +
  geom_text(
    aes(label = paste0(round(RetentionRate, 1), "%"))
  ) +
  scale_fill_gradient(
    low = "white",
    high = "darkblue"
  ) +
  labs(
    title = "Customer Retention By Cohort",
    x = "Months Since First Purchase",
    y = "Cohort Month",
    fill = "Retention Rate (%)"
  ) +
  theme_minimal()

#Cohort Retention Findings
retention_by_month <- retention_counts %>%
  group_by(CohortIndex) %>%
  summarise(
    Avg_Retention = mean(RetentionRate),
    Median_Retention = median(RetentionRate)
  )

retention_by_month

#Initial Retention Plot
ggplot(retention_by_month %>%
         filter(CohortIndex > 0),
       aes(x = CohortIndex,
           y = Avg_Retention)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(
    breaks = seq(1, max(retention_by_month$CohortIndex))
  ) +
  labs(
    title = "Average Customer Retention by Months Since First Purchase",
    x = "Months Since First Purchase",
    y = "Average Retention Rate (%)"
  ) +
  theme_minimal()

retention_counts %>%
  group_by(CohortIndex) %>%
  summarise(
    Cohorts = n(),
    Avg_Retention = mean(RetentionRate),
    Median_Retention = median(RetentionRate)
  )

#Observe limitations of data
retention_counts %>%
  +     filter(CohortIndex == 1) %>%
  +     arrange(CohortMonth)

#Examine the Middle 10 Cohorts
retention_counts %>%
  filter(
    CohortIndex == 1,
    CohortMonth >= "2011-01",
    CohortMonth <= "2011-10"
  ) %>%
  arrange(CohortMonth)

retention_counts %>%
  filter(
    CohortIndex == 1,
    CohortMonth >= "2011-01",
    CohortMonth <= "2011-10"
  ) %>%
  summarise(
    Average = mean(RetentionRate),
    Median = median(RetentionRate),
    SD = sd(RetentionRate),
    Minimum = min(RetentionRate),
    Maximum = max(RetentionRate)
  )

#Six Cohort Analysis
retention_counts %>%
  filter(
    CohortMonth >= "2011-01",
    CohortMonth <= "2011-06",
    CohortIndex >= 1,
    CohortIndex <= 6
  ) %>%
  group_by(CohortIndex) %>%
  summarise(
    Cohorts = n(),
    Average = mean(RetentionRate),
    Median = median(RetentionRate),
    SD = sd(RetentionRate),
    Minimum = min(RetentionRate),
    Maximum = max(RetentionRate)
  )

retention_counts %>%
  filter(
    CohortMonth >= "2011-01",
    CohortMonth <= "2011-06",
    CohortIndex >= 1,
    CohortIndex <= 6
  ) %>%
  select(
    CohortMonth,
    CohortIndex,
    RetentionRate
  ) %>%
  arrange(CohortMonth, CohortIndex) %>%
  print(n = 36)

#Average Retention Graph
retention_counts %>%
  filter(
    CohortMonth >= "2011-01",
    CohortMonth <= "2011-06",
    CohortIndex >= 1,
    CohortIndex <= 5
  ) %>%
  group_by(CohortIndex) %>%
  summarise(
    Avg_Retemtion = mean(RetentionRate),
  ) %>%
  ggplot(
    aes(
      x = CohortIndex,
      y = Avg_Retemtion
    )
  ) +
  geom_line() +
  geom_point() +
  scale_x_continuous(
    breaks = 1:5
  ) +
  labs(
    title = "Average Customer Retention Since Acquisition",
    x = "Months Since First Purchase",
    y = "Average Retention Rate (%)"
  ) +
  theme_minimal()

#Power BI Exports
write.csv(retention_counts,
          "Data/retention_table.csv",
          row.names = FALSE)

write.csv(retention_by_month,
          "Data/retention_summary.csv",
          row.names = FALSE)
