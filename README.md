# Data Analysis

## Cài đặt

- R version >= 4.5.1 (https://www.r-project.org/)

## Các bước phân tích

- Copy file data từ Google Form `Bang_Khao_Sat_Import_Google_Form - Form Responses 1.csv` vào cùng thư mục.
- Chạy lệnh `Rscript step1_handle_data.R` để xử lý, làm sạch dữ liệu.
  - --> Output: `output/data.csv`
- Chạy lệnh `Rscript step2_analysis.R` để chạy mô hình PLS SEM cho `data.csv`
