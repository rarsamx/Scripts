#!/usr/bin/env bash
#
# xmobar helper
## Ouptuts the current keybiard input method
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

IM=$(gdbus call -e -d org.fcitx.Fcitx -o "/inputmethod" -m "org.fcitx.Fcitx.InputMethod.GetCurrentIM" | sed -e "s/('\(.*\)',)/\1/")

case $IM in
    fcitx-keyboard-us)
        echo "US"
        ;;
    fcitx-keyboard-us-intl)
        echo "US intl"
        ;;
    pinyin)
        echo "CH"
        ;;
    sunpinyin)
        echo "CH"
        ;;
    fcitx-keyboard-cn-altgr-pinyin)
        echo "PY"
        ;;
 esac
