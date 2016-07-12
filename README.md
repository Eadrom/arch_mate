# arch_mate
PKGBUILD's for MATE in Arch Linux's

This is currently updated with a cron job (with the script ./update.sh)

Features:

* Updated to latest stable upstream:  1.15.x 
* GTK3 PKGBUILD only
* Build test all packages - everything in ./order is tested. The current methodology is to run them in my main machine as my daily driver.

Known Issues (things i removed from orginal community branch): 
* cannot make mate-sensors-applet as it needs a nvidia package.
* mate-netbook has never worked for me.
* cannot make mate-indicator-applet because arch/aur lacks libido3
