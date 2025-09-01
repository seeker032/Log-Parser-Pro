# Log-Parser-Pro
A lightweight Bash script for parsing and filtering .csv log files. It extracts key fields (IP, Date, Method, URL, Protocol, Status), supports single and dual search filters, and includes optional output compression. Built with robust input validation and user-friendly CLI prompts, it's ideal for quick log analysis and Linux scripting practice.

🔧 Features

Flexible Filtering:
    -s for single-term filtering
    -d for dual-term filtering
    -z to compress the output into a .zip file
Smart Parsing:
    Extracts and restructures log entries into: IP, Date, Method, URL, Protocol, Status
Error Handling:
    Validates file formats, flags, and input arguments
    Provides clear, color-coded error messages
Dynamic Output:
    Auto-generates output filenames using Unix epoch timestamps
    Optionally prompts for custom output filenames

📚 Learning Reflection

This project was a deep dive into Bash scripting, especially coming from an object-oriented programming background (VB, C++, Java, Python). It challenged me to think differently—leveraging Unix tools like grep, sed, and cut instead of traditional libraries. It’s a great stepping stone toward Linux system administration and scripting proficiency.

📦 Output

Processed CSV file with parsed log entries
Optional zipped archive of the results


