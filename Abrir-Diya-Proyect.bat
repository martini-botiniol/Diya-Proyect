@echo off
setlocal
if not exist "%LOCALAPPDATA%\Programs\DiyaProyect\Abrir-Diya-Proyect.bat" (
  echo Ejecuta Preparar-Diya-Proyect.bat primero.
  pause
  exit /b 1
)
call "%LOCALAPPDATA%\Programs\DiyaProyect\Abrir-Diya-Proyect.bat"
