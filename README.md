
# 📄 mygrep.sh

A custom lightweight version of the `grep` command, implemented in Bash.

---

## ✨ Features

- **Case-insensitive** text search.
- **Supported options**:
  - `-n` → Display line numbers for matches.
  - `-v` → Invert match (show lines **not** containing the search term).
- **Combination of options** (`-vn`, `-nv`, etc.) is fully supported.
- **Error handling** for missing files and incorrect inputs.
- **`--help`** flag to display usage instructions.

---

## 🛠️ Installation

1. Clone this repository or download the `mygrep.sh` file.
2. Make the script executable:
   ```bash
   chmod +x mygrep.sh
   ```
3. (Optional) Move it to `/usr/local/bin` for system-wide usage:
   ```bash
   sudo mv mygrep.sh /usr/local/bin/mygrep
   ```

---

## 🚀 Usage

```bash
./mygrep.sh [options] search_text filename
```

### 📌 Options:
| Option | Description                            |
|:------:|:---------------------------------------|
| `-n`   | Show line numbers for matches           |
| `-v`   | Invert matching (show lines without match) |
| `--help` | Display usage information             |

### 📚 Examples

```bash
./mygrep.sh hello testfile.txt
./mygrep.sh -n hello testfile.txt
./mygrep.sh -vn hello testfile.txt
./mygrep.sh -v testfile.txt
```

---

## 🧪 Test File (`testfile.txt`)
```
 Hello world
 This is a test
 another test line
 HELLO AGAIN
 Don't match this line
 Testing one two three
```

---

## 🛡️ Validation

✅ Tested successfully with:

- Normal match
- Line numbers display
- Inverted matches
- Missing search text (error handling)

---

## 🧠 Reflection

### How the script handles arguments and options:

- Used `getopts` to parse `-n` and `-v` flags flexibly.
- Detected `--help` manually before option parsing.
- Checked argument count and file existence after parsing.
- Converted both the search term and each line to lowercase for consistent case-insensitive comparison.
- Applied match inversion if `-v` was specified.

### How structure would change to support regex or additional options (`-i`, `-c`, `-l`):

- Would enhance matching logic to support regex using Bash’s `[[ ]]`, `grep`, or even `awk`.
- `-c` (count) would require counting matches instead of printing them.
- `-l` (list files) would print only the filename if a match exists.
- Might refactor file processing into functions to keep the code clean as features expand.

### Most challenging part:

- Correctly parsing and managing combinations like `-vn` and `-nv` using `getopts`.
- Making sure the inverted match logic didn’t interfere with regular match behavior.
- Balancing feature support while keeping the script easy to maintain and understand.

---

## 🎯 Bonus Features

- Added a `--help` flag to display a help guide.
- Used `getopts` for robust option parsing.


![Screenshot From 2025-04-28 13-52-45](https://github.com/user-attachments/assets/37e33629-6efd-428d-a449-25e263e693f3)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Q2)

🛠️ Troubleshooting Internal DNS Resolution Issue


To simulate and troubleshoot the issue, I have intentionally:
1. Broke DNS Resolution:
```
   Edited /etc/resolv.conf and set an invalid nameserver like 1.2.3.4.
```
---
2. Blocked HTTP Traffic:
---
   Used UFW firewall to deny HTTP traffic:
  ```
 sudo ufw deny 80/tcp
  ```          
Tested DNS Resolution Using internal DNS:

       Command:
       dig internal.example.com
```
Result:
  The query timed out (no response).

Analysis:
  So either:
        1. The system's DNS server was wrongly configured.
        2. Or the internal DNS server was unresponsive.

```


![image](https://github.com/user-attachments/assets/198b4d16-032b-455a-9686-9cd7c09501b4)




Tested DNS Resolution Using Public DNS (8.8.8.8)
```
    • Command:
      dig @8.8.8.8 internal.example.com
```
• Result:
  Received an NXDOMAIN (non-existent domain) response.
```
• Analysis:
    ◦ Google's DNS (8.8.8.8) does not know internal domains.
    ◦ This is expected behavior.
    ◦ Conclusion: The issue lies with the internal DNS server, not with public DNS.
```


![image](https://github.com/user-attachments/assets/254ecdb2-1ca2-46c8-a1b3-06358e83919a)




Checked /etc/resolv.conf
```
    • Command:
      cat /etc/resolv.conf
    • Result:
Found a wrong or non-functional DNS server IP configured.
```

  • Analysis:

        
        ◦ If /etc/resolv.conf points to the wrong DNS server, name resolution will fail.
        ◦ It must point to the correct internal DNS server.



Verified Network Connectivity
    • Commands:
      ping internal.example.com
      traceroute internal.example.com

    
    • Result:
        ◦ No successful ping or incomplete traceroute if DNS is broken.
        ◦ Helped confirm whether it was a DNS or network routing issue.


Tested Web Server VirtualHost Configuration
    • Command:
      curl -v http://internal.example.com


    • Result:
        ◦ A proper HTTP/1.1 200 OK or page content indicated that the web server itself was healthy.




To bypass DNS temporarily during troubleshooting, I edited /etc/hosts:
```
sudo nano /etc/hosts
Added:
192.168.0.120 internal.example.com
```


![image](https://github.com/user-attachments/assets/46704ff2-2d7e-4d78-9a26-898bddb7d52b)




The Ubuntu firewall (UFW) is disabled.
    • So firewall blocking is NOT the cause of your DNS timeout issue.


![image](https://github.com/user-attachments/assets/7f303a2b-e54e-47ef-9b44-77d3984951b8)



Conclusion:
this is the flow chart I have followed:
"Client → DNS Request → Internal DNS → Web Server Response"



