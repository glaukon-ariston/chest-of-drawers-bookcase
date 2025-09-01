@echo off
: set OPENSCAD=C:\Program Files\OpenSCAD\openscad.exe
set OPENSCAD=openscad
set TEMP_CSV=artifacts\temp_cut_list.csv
set FINAL_CSV=artifacts\cut_list.csv

"%OPENSCAD%" -o "artifacts/model.png" --imgsize=1920,1080 -D generate_cut_list_csv=true model.scad 2> %TEMP_CSV%

(
    rem Use ^" to represent the literal quote character as a delimiter
    for /f tokens^=2^ delims^=^" %%a in ('findstr /b "ECHO: " "%TEMP_CSV%"') do (
        echo %%a
    )
) > "%FINAL_CSV%"

rem del %TEMP_CSV%