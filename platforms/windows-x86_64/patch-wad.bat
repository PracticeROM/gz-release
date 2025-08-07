@echo off
setlocal

set GZINJECT=bin\gzinject.exe
echo 45e | bin\gzinject.exe -a genkey -k common-key.bin >nul
bin\gru.exe lua/patch-wad.lua %*
del common-key.bin
rmdir /s /q wadextract
