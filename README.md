
# 🧾 Log-Parser-Pro

A lightweight Bash script for parsing and filtering `.csv` log files. It extracts key fields (IP, Date, Method, URL, Protocol, Status), supports single and dual search filters, and includes optional output compression. Built with robust input validation and user-friendly CLI prompts, it's ideal for quick log analysis and Linux scripting practice.

---

## 🔧 Features

**Flexible Filtering**  
- `-s` for single-term filtering  
- `-d` for dual-term filtering  
- `-z` to compress the output into a `.zip` file  

**Smart Parsing**  
- Extracts and restructures log entries into: IP, Date, Method, URL, Protocol, Status  

**Error Handling**  
- Validates file formats, flags, and input arguments  
- Provides clear, color-coded error messages  

**Dynamic Output**  
- Auto-generates output filenames using Unix epoch timestamps  
- Optionally prompts for custom output filenames

---

## ▶️ Options

### Single search term

 `./logparserpro.sh -s "GET"`

### Two search terms

 `./logparserpro.sh -d "200,POST"`

### Run the script with a search term and zip the output

 `./logparserpro.sh -s "404" -z`

### Run the script without any filters (default mode)

 `./logparserpro.sh`

---

📋 Step-by-Step Instructions

### 1. Prepare your log file

Ensure your input file is in .csv format and contains log entries structured with fields like IP, timestamp, request method, URL, protocol, and status code.

### 2. Prepare your log file

 `chmod +x logparserpro.sh`

### 3. Run the script with desired options

Use  `-s`,  `-d`, or  `-z` flags as needed. The script will prompt you for the input and output file names if not provided.

### 4. View the results
The output will be saved in a new .csv file with parsed and filtered log entries. If  `-z` is used, a zipped version will also be created.

### 5. Check the terminal output
The script will display how many records were processed and confirm the output file name.

---

## 📚 Learning Reflection

This project was a deep dive into Bash scripting, especially coming from an object-oriented programming background (VB, C++, Java, Python). It challenged me to think differently—leveraging Unix tools like `grep`, `sed`, and `cut` instead of traditional libraries. It’s a great stepping stone toward Linux system administration and scripting proficiency.

---

## 📦 Output

- Processed CSV file with parsed log entries  
- Optional zipped archive of the results

---
