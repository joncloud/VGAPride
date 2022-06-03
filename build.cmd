@ECHO OFF
@REM This script is intended to be launched from the host
@REM operating system to perform builds.

WHERE /q dosbox-x
IF ERRORLEVEL 1 (
  SET "PATH=%PATH%;C:\DOSBox-X"
)
WHERE /q dosbox-x
IF ERRORLEVEL 1 (
  ECHO Missing DOSBox-X installation
  ECHO Please install DOSBox-X and try again
  EXIT
)

IF NOT EXIST "%CD%\.borland\drivea" (
  @REM If the BORLANDDOWNLOAD variable is not set, then just exit.
  IF "%BORLANDDOWNLOAD%" == "" (
    ECHO Missing Borland Turbo C++ 3.0 Installation Media
    ECHO Download disk images, and extract all to %CD%\.borland\drivea
    EXIT
  )

  IF NOT EXIST "%CD%\.borland.7z" (
    curl %BORLANDDOWNLOAD% -o .borland.7z
  )

  7z x .borland.7z
)

@REM If the compiler hasn't been installed, use the media to install it
IF NOT EXIST "%CD%\.borland\drivec" (
  MKDIR "%CD%\.borland\drivec"

  dosbox-x -nopromptfolder ^
    -fastlaunch ^
    -c "MOUNT A %CD%\.borland\drivea" ^
    -c "MOUNT C %CD%\.borland\drivec" ^
    -c "PATH %%PATH%%;C:\TC\BIN" ^
    -c "A:" ^
    -c "INSTALL.EXE"
)

IF NOT EXIST "%CD%\.borland\drivec\TC\BIN\TCC.EXE" (
  ECHO Missing Borland Turbo C++
  ECHO Try removing %CD%\.borland\drivec and run this script again
  EXIT
)

IF EXIST "%CD%\drivec" (
  RMDIR /S /Q "%CD%\drivec"
)

@REM Setup the dosbox environment
MKDIR "%CD%\drivec" >NUL
MKDIR "%CD%\drivec\TC" >NUL
XCOPY /E /Y "%CD%\.borland\drivec\TC" "%CD%\drivec\TC" >NUL

MKDIR "%CD%\drivec\VGAPRIDE" >NUL
COPY * "%CD%\drivec\VGAPRIDE" >NUL

@REM Do the actual build in dosbox
dosbox-x -nopromptfolder -exit ^
  -fastlaunch ^
  -c "MOUNT C %CD%\drivec" ^
  -c "PATH %%PATH%%;C:\TC\BIN" ^
  -c "C:" ^
  -c "VGAPRIDE\BUILD.BAT"

@REM Print out any log messages in case of error
SET BUILD-LOG="%CD%\drivec\VGAPRIDE\BUILD.LOG"
IF EXIST "%BUILD-LOG%" (
  TYPE "%BUILD-LOG%"
  DEL "%BUILD-LOG%"
)

IF EXIST "%CD%\drivec\VGAPRIDE\VGAPRIDE.EXE" (
  PUSHD %CD%\drivec\VGAPRIDE\
  upx VGAPRIDE.EXE
  7z a vgapride.zip VGAPRIDE.EXE
  POPD
)
