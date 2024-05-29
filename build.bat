@echo off

IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL

build_tools\asw -xx -q -A -L -U -E -i . sonic.asm
build_tools\p2bin -p=0 -z=0,kosinskiplus,Size_of_DAC_driver_guess,after sonic.p s1built.bin

del sonic.p