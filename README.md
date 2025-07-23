# Data Analysis

## Cài đặt

- Máy tính ở local cần có:
  - R phiên bản >= 4.5.1 (https://www.r-project.org/)
  - RStudio IDE (https://posit.co/download/rstudio-desktop/)
- Clone source code bằng lệnh `git clone https://github.com/rudyhuynh/ecm-pls.git` hoặc tải trực tiếp từ Github.

## Các bước thực thi

- Copy file data `Bang_Khao_Sat_Import_Google_Form - Form Responses 1.csv` tải về từ Google Form vào cùng thư mục chứa file `README.md` này.
- Chạy lệnh `Rscript handle_data.R` để xử lý và làm sạch dữ liệu từ Google Form --> output: `data.csv`
- Import `data.csv` và `studio.R` vào RStudio IDE.
- Chạy các lệnh cần thiết trong `studio.R` bằng RStudio IDE để phân tích mô hình và plot model.

## Reference

- Hair Jr, J. F., Hult, G. T. M., Ringle, C. M., Sarstedt, M., Danks, N. P., & Ray, S. (2021). Partial least squares structural equation modeling (PLS-SEM) using R: A workbook. Springer Nature
  https://doi.org/10.1007/978-3-030-80519-7
