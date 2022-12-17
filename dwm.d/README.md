Rebuilding this dwm package
===

* Install dwm.

* Download the source and install build-deps `sudo apt build-dep dwm`.

* Copy `config.def.h` to the source root as `config.h`.

* Build dwm `make`

* Register the new dwm flavour `sudo update-alternatives --install /usr/bin/dwm dwm /usr/bin/dwm.lumin 999`

* switch dwm alternative `sudo update-alternatives --config dwm`.

ref: https://wiki.archlinux.org/index.php/Dwm

ref: https://wiki.archlinux.org/index.php/Desktop_entries
