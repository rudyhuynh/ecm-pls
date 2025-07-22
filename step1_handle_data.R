options(repos = "https://cloud.r-project.org")

local_lib <- "./R_packages"
if (dir.exists(local_lib)) {
    cat("Local library found at:", local_lib, "\n")
} else {
    cat("Local library not found. Create directory and install package...\n")
    dir.create(local_lib, showWarnings = FALSE, recursive = TRUE)

    install.packages("dplyr", lib = local_lib)
}

library(dplyr, lib.loc = local_lib)
#----------------

INPUT = "Bang_Khao_Sat_Import_Google_Form - Form Responses 1.csv"
OUTPUT = "data.csv"

data <- read.csv(INPUT)

cat("Number of columns in data:", ncol(data), "\n")

# Remove vietnamese tone marks
convert_vietnamese_to_ascii <- function(text) {
  text <- as.character(text)
  
  text <- gsub("à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ", "a", text)
  text <- gsub("À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ", "A", text)
  text <- gsub("è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ", "e", text)
  text <- gsub("È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ", "E", text)
  text <- gsub("ì|í|ị|ỉ|ĩ", "i", text)
  text <- gsub("Ì|Í|Ị|Ỉ|Ĩ", "I", text)
  text <- gsub("ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ", "o", text)
  text <- gsub("Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ", "O", text)
  text <- gsub("ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ", "u", text)
  text <- gsub("Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ", "U", text)
  text <- gsub("ỳ|ý|ỵ|ỷ|ỹ", "y", text)
  text <- gsub("Ỳ|Ý|Ỵ|Ỷ|Ỹ", "Y", text)
  text <- gsub("đ", "d", text)
  text <- gsub("Đ", "D", text)
  
  return(text)
}

data[] <- lapply(data, function(x) {
  if(is.character(x) || is.factor(x)) {
    convert_vietnamese_to_ascii(x)
  } else {
    x
  }
})
#------

# Column Mapping
new_column_names <- c(
  "timestamp",   #A Timestamp
  "age",   #B Tuoi cua ban
  "job",   #C Nghe nghiep hien tai
  "is_learning_new_language",   #D Ban co dang hoc ngon ngu moi khong?
  "has_using_flashcard_app",   #E Ban co dang su dung app hoc tu vung Flashcard de ho tro viec hoc khong?
  "learning_topics",   #F Ban su dung app de hoc ve nhung de tai nao sau day...
  "apps_used",   #G Apps used
  "PU1",   #H Benefit 1 - Save time
  "PU2",   #I Benefit 2 - Remember longer
  "PU3",  #J Benefit 3 - Deep understanding
  "PU4",  #K Benefit 4 - Effective method
  "PU5",  #L Benefit 5 - Test scores
  "platform",  #M Platform
  "other_benefits",  #N Other benefits
  "FI1",  #O Bạn quan tâm đến những tính năng...? - Spaced repetition
  "c16",  #P Bạn quan tâm đến những tính năng...? - Notification
  "FI2",  #Q Bạn quan tâm đến những tính năng...? - Giao diện thân thiện, dễ sử dụng
  "FI3",  #R Bạn quan tâm đến những tính năng...? - Giao diện đẹp, bắt mắt
  "FI4",  #S Bạn quan tâm đến những tính năng...? - Có bộ sưu tập từ vựng phong phú
  "c20",  #T Feature interest 6 - Dictionary
  "FI5",  #U Bạn quan tâm đến những tính năng...? - Giúp luyện tập kỹ năng nghe
  "FI6",  #V Bạn quan tâm đến những tính năng...? - Speaking
  "FI9",  #W Bạn quan tâm đến những tính năng...? - Reading
  "FI10",  #X Bạn quan tâm đến những tính năng...? - Writing
  "FI11",  #Y Bạn quan tâm đến những tính năng...? - Nhiều tuỳ chỉnh trong việc tạo thẻ từ vựng
  "c26",  #Z Column 25
  "c27",  #AA Improvement suggestions
  "c28",  #AB Column 27
  "PEOU1",  #AC Current app rating 1
  "PEOU2",  #AD Current app rating 2
  "PEOU3_",  #AE Tôi cần hướng dẫn để sử dụng các chức năng quan trọng trong app
  "PEOU4",  #AF Current app rating 4
  "PI1_",  #AG Bạn có sẵn sàng trả phí cho app học từ vựng hiện tại của bạn không?
  "PI2_",  #AH Trong suốt thời gian học, bạn đã chi trả bao nhiêu cho ứng dụng học từ vựng hiện tại? (VND)
  "app_refer",  #AI How discovered app
  "FI12",  #AJ Bạn quan tâm đến những tính năng nào sau đây...? Giúp tạo ra lộ trình học phù hợp với kiến thức của tôi
  "PEOU_OTHER",  #AK Other feedback
  "monthly_price_exp",  # Premium price expectation
  "SAT1",  #AM Overall satisfaction
  "SAT2",  #AN Feature satisfaction
  "c41",  #AO Expectation 1
  "CONF1",  #AP Trải nghiệm thực tế của tôi với ứng dụng học từ vựng tốt hơn so với kỳ vọng ban đầu.
  "c43",  #AQ Expectation 3
  "CONF2",  #AR Các chức năng mà ứng dụng cung cấp vượt hơn mong đợi của tôi.
  "CONF3",  #AS Nhìn chung, ứng dụng học từ vựng đã đáp ứng hầu hết kỳ vọng ban đầu của tôi.
  "improve_need1",  #AT Improvement need 1
  "improve_need2",  #AU Improvement need 2
  "improve_need3",  #AV Improvement need 3
  "improve_need4",  #AW Improvement need 4
  "improve_need5",  #AX Improvement need 5
  "improve_need6",  #AY Improvement need 6
  "improve_need_other",  #AZ Other improvements
  "use_freq",  #BA Bạn sử dụng ứng dụng học từ vựng được bao lâu rồi?
  "HAB1",  #BB Habit 1
  "HAB2",  #BC Habit 2
  "HAB3",  #BD Habit 3
  "gender",  #BE Gender
  "email",  #BF Email
  "interest_in_flashcard_app",  #BG Interest in flashcard
  "c60",  #BH Column 58
  "c61",  #BI Column 58
  "c62",  #BJ
  "c63",  #BK
  "c64",  #BL 
  "c65",  #BM
  "c66",
  "c67"
)

colnames(data) <- new_column_names[1:ncol(data)]
# Make sure no empty columns
temp_data <- data.frame(matrix(ncol = length(new_column_names), nrow = nrow(data)))

for(i in 1:length(new_column_names)) {
  colnames(temp_data)[i] <- new_column_names[i]
}

for(i in 1:ncol(data)) {
  if(i <= length(new_column_names)) {
    temp_data[, i] <- data[, i]
  }
}

data <- temp_data
#------

# Map Fields
data$PI1 <- ifelse(data$`PI1_` == "Co", 1, 0)
data$PI2 <- case_when(
  data$`PI2_` == "0d" ~ 0,
  data$`PI2_` == "Duoi 20k" ~ 1,
  data$`PI2_` == "20k - 100k" ~ 2,
  data$`PI2_` == "100k - 300k" ~ 3,
  data$`PI2_` == "300k - 1 trieu" ~ 4,
  data$`PI2_` == "Tren 1 trieu" ~ 5,
  TRUE ~ 0  # Default for any other values
)
data$PEOU3 <- case_when(
  data$`PEOU3_` == 1 ~ 5,
  data$`PEOU3_` == 2 ~ 4,
  data$`PEOU3_` == 3 ~ 3,
  data$`PEOU3_` == 4 ~ 2,
  data$`PEOU3_` == 5 ~ 1,
  TRUE ~ 3 
)
#-------

# Filter data row
cat("Data rows before filtering:", nrow(data), "\n")

# Exclude due to one-type responders and self testing data
excluded_timestamp <- c(
  "6/23/2025 23:10:46",
  "6/26/2025 2:57:55",
  "7/9/2025 6:30:51",
  "6/26/2025 23:22:15",
  "7/16/2025 21:51:00",
  "7/16/2025 9:10:49",
  "7/16/2025 9:31:52",
  "7/9/2025 7:34:46",
  "7/9/2025 5:42:28",
  "7/9/2025 7:37:29",
  "7/16/2025 10:25:26"
)

# Included due to face-to-face feedback and/or provide valuable insights
included_timestamp <- c(
  "6/26/2025 11:09:07",
  "6/27/2025 2:43:41",
  "7/9/2025 5:26:45",
  "7/9/2025 10:31:35",
  "7/17/2025 3:05:23"
)

data <- data %>%
  filter(!timestamp %in% excluded_timestamp)
data <- data %>%
  filter((is_learning_new_language == "Co" & has_using_flashcard_app == "Co") | timestamp %in% included_timestamp)
cat("Data rows after filtering:", nrow(data), "\n")

# Remove unnecessary columns
selected_columns <- c(
  "timestamp",
  "HAB1", "HAB2", "HAB3", 
  "PU1", "PU2", "PU3", "PU4", "PU5", 
  "SAT1", "SAT2",
  "PEOU1", "PEOU2", "PEOU3", "PEOU4", 
  "CONF1", "CONF2", "CONF3", 
  "PI1", "PI2")

# Keep only columns that exist in the data
existing_columns <- intersect(selected_columns, colnames(data))
data <- data[, existing_columns]
#------

write.csv(data, OUTPUT)
cat("Data saved to", OUTPUT, "\n")
cat("\twith ", nrow(data), "rows and", ncol(data), "columns\n")