#!/usr/bin/env bash
# ==================================================
# Get distro color and glyph.
# For use in fancy prompt etc.
# --------------------------------------------------

case $(uname) in
Linux)
    case $(grep -P -o '(?<=^ID=)("?[a-z]+"?)$' /etc/os-release | tr -d '"') in
    arch)    _color='15;148;210'; _glyph=' '; ;;
    bsd)     _color='119;0;0'   ; _glyph=' '; ;;
    centos)  _color='239;167;36'; _glyph=' '; ;;
    debian)  _color='199;0;54'  ; _glyph=' '; ;;
    fedora)  _color='0;69;126'  ; _glyph=' '; ;;
    manjaro) _color='53;191;92' ; _glyph=' '; ;;
    opensuse)_color='115;186;37'; _glyph=' '; ;;
    raspbian)_color='195;28;74' ; _glyph=' '; ;;
    redhat)  _color='238;0;0'   ; _glyph=' '; ;;
    ubuntu)  _color='233;84;32' ; _glyph=' '; ;;
    *)       _color='0;0;0'     ; _glyph=' '; ;;
    esac
    ;;
Darwin)
    _color='255;255;255'; _glyph=' '
    ;;
*)
    _color='174;174;174'; _glyph=''
    ;;
esac
_color="[38;2;${_color}m"

echo -ne "${_color} ${_glyph}"
