@ECHO OFF
@REM This script is intended to be launched from within DosBox-X

C:
CD C:\TC\BGI
BGIOBJ EGAVGA > BUILD.LOG
COPY EGAVGA.OBJ C:\VGAPRIDE

CD C:\VGAPRIDE
TC /b VGAPRIDE.PRJ >> BUILD.LOG
