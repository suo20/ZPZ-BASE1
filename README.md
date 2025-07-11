# 🛰️ ZPZ (Base 1) by YuiKo

ZPZ (Base 1) adalah tool Reconnaissance berbasis Ruby yang simpel dan modular.  
Dapat dijalankan secara **native** di Android (Termux), Linux (Ubuntu, Debian, Arch, Fedora, openSUSE, dll).

>  Cocok untuk OSINT dasar, bug bounty, dan footprinting pasif.

---

## FITUR UTAMA

-  DNS Lookup (`A`, `AAAA`, `MX`, `NS`)
-  WHOIS Lookup
-  GeoIP Lookup (lokasi IP)
-  Subdomain Finder (brute-force)
-  Port Scanner (multithreaded)
-  Mode Silent / Verbose
-  Auto save ke `output/results.txt`

---

## CARA INSTALASI (SEMUA OS)

### Debian/Ubuntu/Kali linux
```bash
sudo apt update && sudo apt install ruby git -y
git clone https://github.com/suo20/ZPZ-BASE1
cd ZPZ-Base1
ruby zpz.rb -d example.com --all

### Arch/Manjaro/EndevourOS
sudo pacman -Syu ruby git
git clone https://github.com/suo20/ZPZ-BASE1
cd ZPZ-Base1
ruby zpz.rb -d example.com --all

### Fedora/CentOS/RHEL
sudo pacman -Syu ruby git
git clone https://github.com/suo20/ZPZ-BASE1
cd ZPZ-Base1
ruby zpz.rb -d example.com --all


### Android (Termux)
```bash
pkg update && pkg upgrade -y
pkg install ruby git -y
git clone https://github.com/suo20/ZPZ-BASE1
cd ZPZ-Base1
ruby zpz.rb -d example.com --all
