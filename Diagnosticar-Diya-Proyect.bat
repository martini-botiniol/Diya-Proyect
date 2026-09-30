@echo off
setlocal
if not exist "%LOCALAPPDATA%\Programs\DiyaProyect\Diagnosticar-Diya-Proyect.bat" (
  echo Ejecuta Preparar-Diya-Proyect.bat primero.
  pause
  exit /b 1
)
call "%LOCALAPPDATA%\Programs\DiyaProyect\Diagnosticar-Diya-Proyect.bat" %*
