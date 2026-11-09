#  Xen

***Xen*** is a image based,  Linux Distro built using `bootc` - no bloat & minimal and the filesystem is **readonly**

![images](images/home.png)

![images](images/menu.png)

### Update & Maintain
- status and available updates
` bootc status `
- upgrade to latest version
`sudo bootc upgrade && sudo systemctl reboot`
- rollback to a previous version `sudo bootc rollback && systemctl reboot`
- enable temporary writable /usr `sudo bootc usr-overlay`

### Apps Pre-installed 

- firefox
- image viewer
- kitty
- gnome files
- gnome settings
- gnome disks
- vlc
- neovim
- btop
- fastfetch

### Flatpak apps - not Pre-installed
**note: these apps install automatically after the os installs**

- obsidian

### Dev tools Pre-installed
 - gcc
- gcc-c++
- clang 
- clang-tools-extra
- cmake
-  ninja-build
- make 
- gdb 
- lldb 
- valgrind 
- git
- curl
-  kgconf-pkg-config
- openssl-devel 
- python3
- python3-pip 
- python3-devel 

### Build ISO *Manual way*
```bash
git clone https://github.com/xenxaarn/xen && cd xen && ./build.sh
```

### License
[MIT](LICENSE)
