# Data Analysis

## Cài đặt

- Máy tính ở local cần có: R phiên bản >= 4.5.1 (https://www.r-project.org/)
- Clone source code bằng lệnh `git clone https://github.com/rudyhuynh/ecm-pls.git` hoặc tải trực tiếp từ Github.

## Các bước phân tích

- Copy file data `Bang_Khao_Sat_Import_Google_Form - Form Responses 1.csv` tải về từ Google Form vào cùng thư mục chứa file `README.md` này.
- Chạy lệnh `Rscript step1_handle_data.R` để xử lý, làm sạch dữ liệu từ Google Form --> output: `data.csv`
- Chạy lệnh `Rscript step2_analysis.R` để chạy mô hình PLS-SEM cho `data.csv`

## Reference

- Hair Jr, J. F., Hult, G. T. M., Ringle, C. M., Sarstedt, M., Danks, N. P., & Ray, S. (2021). Partial least squares structural equation modeling (PLS-SEM) using R: A workbook. Springer Nature
  https://doi.org/10.1007/978-3-030-80519-7
