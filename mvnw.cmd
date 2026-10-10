@REM Jobify Maven Wrapper for Windows
@echo off
setlocal

set "PREFERRED_MVN=C:\Users\NIDHI\Downloads\apache-maven-3.10.0-bin\apache-maven-3.10.0\bin\mvn.cmd"

if exist "%PREFERRED_MVN%" (
    call "%PREFERRED_MVN%" %*
) else (
    where mvn >nul 2>nul
    if %ERRORLEVEL% equ 0 (
        call mvn %*
    ) else (
        echo [ERROR] Maven not found. Please install Maven or check path: %PREFERRED_MVN%
        exit /b 1
    )
)
