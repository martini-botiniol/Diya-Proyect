@echo off
setlocal
if defined DIYA_PROYECT_PYTHON (
  "%DIYA_PROYECT_PYTHON%" "%~dp0scripts\prepare_diya_proyect.py" %*
) else (
  where py >nul 2>&1
  if not errorlevel 1 (
    py -3 "%~dp0scripts\prepare_diya_proyect.py" %*
  ) else (
    python "%~dp0scripts\prepare_diya_proyect.py" %*
  )
)
if errorlevel 1 (
  echo No se pudo preparar Diya Proyect. Revisa el error anterior.
  echo Se requiere Python 3.11 o superior con Tcl/Tk y pip.
  echo Puedes definir DIYA_PROYECT_PYTHON con la ruta a python.exe.
  pause
  exit /b 1
)
echo Diya Proyect listo. Usa el acceso directo del escritorio o Abrir-Diya-Proyect.bat.
