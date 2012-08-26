@echo OFF
REM TODO use the call command to set some variables common to both the installer/uninstaller
set PERL_VERSION=5.12.3.0
set APACHE_VERSION=2.2.21
set WAMP_VERSION=2.2a

set ADDON=Perl

set BIN=installer\bin
set TMP=installer\temp

set WAMP=c:\wamp
set WAMP_PERL=%WAMP%\bin\perl

set PERL_FILE=strawberry-perl-%PERL_VERSION%.msi
set PERL_DIR=perl%PERL_VERSION%
set PERL_BIN=%WAMP_PERL%\%PERL_DIR%

set PERL_DOWNLOAD=http://strawberry-perl.googlecode.com/files/%PERL_FILE%

set PATH=%PATH%;%BIN%

echo Welcome to the %ADDON% Addon installer for WampServer %WAMP_VERSION%

REM set up the temp directory
IF NOT EXIST %TMP% GOTO MKTMP
echo 	Temp directory found from previous install: DELETING
rd /S /Q %TMP%

:MKTMP
echo 	Setting up the temp directory...
mkdir %TMP%

REM download Perl files to temp directory
echo 	Downloading %ADDON% binaries to temp directory...
wget.exe -nd -q -P %TMP% %PERL_DOWNLOAD%
if not %ERRORLEVEL%==0 (echo FAIL: could not download %ADDON% binaries& pause& exit 1)

REM install the binary files in the WampServer install directory
echo 	Installing %ADDON% to the WampServer install directory...
msiexec /i %TMP%\%PERL_FILE% /passive TARGETDIR=%PERL_BIN%
if not %ERRORLEVEL%==0 (echo FAIL: could not install %ADDON% binaries& pause& exit 1)

REM add the Perl bin directory to the PATH so apache can find them
echo 	Setting enviorment variables...
setenv -a PATH %PERL_BIN%\bin

REM clean up temp files
echo 	Cleaning up temp files...
rd /S /Q %TMP%

echo %ADDON% is installed successfully. Please restart WampServer.

pause
