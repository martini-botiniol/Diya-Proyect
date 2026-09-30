# Diya Proyect 0.2

Aplicación Windows que convierte SSD extraíbles en cartuchos portátiles para Steam.
Conecta un cartucho: Diya Proyect lo valida, lo registra localmente y solicita a Steam abrir
el juego o completar su instalación. No necesita una PC creadora ni un servicio central.
Steam conserva el control de cuentas, licencias, descargas y ejecución.

## Uso entre amigos

1. Instala Diya Proyect y Steam en cada PC.
2. Crea el cartucho desde Opciones > Crear cartucho.
3. En cada PC, si Steam lo solicita, añade la carpeta `SteamLibrary` del SSD en
   Steam > Parámetros > Almacenamiento. Selecciona esa biblioteca al instalar.
4. Después basta conectar el cartucho con Diya Proyect abierto en la bandeja.
5. Para cartuchos antiguos, selecciona el disco y pulsa **Preparar para usar en
   cualquier PC** una sola vez. La firma antigua puede no ser verificable allí;
   la conversión es una aceptación explícita y conserva respaldo.

Antes de retirar físicamente el SSD, termina juegos y descargas que lo utilicen.
Diya Proyect cancela sus esperas al desconectar, pero no cierra juegos a la fuerza.

Antes de enviar una solicitud a Steam, Diya Proyect comprueba la escritura en
`SteamLibrary/steamapps` con un archivo temporal que elimina al terminar.
Si falla, muestra la ruta afectada y detiene la solicitud. Esta comprobación
no garantiza espacio suficiente para una descarga ni permisos sobre cada archivo
del juego. La app no cambia automáticamente la protección de escritura del disco.
Para trasladar un juego, el SSD debe conservar tanto su carpeta en
`steamapps/common` como su `steamapps/appmanifest_<AppID>.acf`; el manifiesto
de Diya Proyect solo identifica el juego y no contiene su instalación.

El archivo `.cartridge/write.lock` coordina las operaciones de Diya Proyect. Permanece
en el SSD, pero su existencia no significa que esté bloqueado: Windows libera
el bloqueo al cerrar el archivo o terminar el proceso. No protege el disco
contra escritura ni bloquea los archivos del juego. No lo borres durante una
operación. La espera por un bloqueo ocupado tiene un límite de 10 segundos,
tras el cual se informa el error y se puede reintentar. Este límite no cubre
una operación de entrada/salida que el propio dispositivo deje sin responder.

## Paquete autónomo Windows

Extrae completo `Diya-Proyect-0.2.0-windows-x64.zip`. Conserva `DiyaProyect.exe` junto a `_internal`.
Puedes abrir `DiyaProyect.exe` o ejecutar `Instalar-Diya-Proyect.bat` para crear accesos directos.
El paquete incluye Python/Tk y dependencias: no requiere instalar Python ni usar
el checkout. Las actualizaciones conservan la generación anterior y la preferencia
actual de inicio con Windows. El binario local no tiene firma comercial; las
políticas de Windows pueden impedir su ejecución.

Desde el menú Inicio, **Desinstalar DiyaProyect** retira los accesos y el inicio automático.
Después de cerrar la bandeja, elimina la carpeta de instalación indicada para
liberar espacio. La biblioteca de usuario y los SSD se conservan.

## Desarrollo

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -e ".[dev,build]"
.\.venv\Scripts\python.exe -m pytest
.\.venv\Scripts\python.exe -m cartridge_launcher.app.main tray --open-window
.\.venv\Scripts\python.exe scripts/package_standalone.py
```

El build requiere un Python Windows con Tcl/Tk completo. Ejecuta pruebas, construye
el paquete y verifica su comando `self-check` antes de crear el ZIP. Las versiones
de ejecución y construcción están fijadas; el paquete conserva un inventario del
entorno. No se promete identidad binaria byte por byte entre builds.

## Distribución Python existente

Se conserva `Preparar-Diya-Proyect.bat` y `scripts/package_diya_proyect.py` para pruebas internas.
Esta alternativa necesita Python 3.11+ con Tcl/Tk, pip, venv e internet durante
la preparación. Instala una wheel en un entorno versionado por usuario, sin
instalación editable. Python debe permanecer disponible. Para actualizar,
repite la preparación y reinicia Diya Proyect desde la bandeja.

## Consola

```powershell
diya-proyect create --root G:\ --display-name "Mi juego" --app-id 111
diya-proyect update --root G:\ --display-name "Otro juego" --app-id 222
diya-proyect convert --root G:\
diya-proyect repair --root G:\ --display-name "Mi juego" --app-id 111
diya-proyect tray --steam-action auto
```

## Datos y autorización

El manifiesto V2 contiene autorización AES-256-GCM y se escribe de forma atómica.
La clave común de Diya Proyect facilita el reconocimiento sin internet; puede extraerse de
la aplicación y **no constituye una certificación infalsificable del emisor**.
V1 conserva compatibilidad local y puede convertirse explícitamente en cualquier PC.

El registro, respaldos, portadas y logs viven en `%USERPROFILE%\.3sd`.
Consulta [MANUAL.md](MANUAL.md) y la [matriz de aceptación](docs/ACCEPTANCE.md).


### Operaciones desde el centro de control

Cada tarjeta de la biblioteca incluye **Eliminar cartucho** para quitar su registro
de esta PC, aunque el SSD ya no exista o esté desconectado. Conserva los archivos
del SSD y la instalación de Steam. Al volver a conectar un cartucho eliminado,
Diya Proyect puede registrarlo de nuevo.

Abre **Opciones de cartucho**, recogida por defecto. Encontrarás **Crear cartucho**,
**Actualizar cartucho** y la sección **Reparar cartucho**, con **Reparar** y
**Preparar para usar en cualquier PC**. Windows y Actividad también empiezan recogidas.

Cada operación abre un único formulario: selecciona explícitamente el SSD y después
el juego por búsqueda o por nombre y AppID. Actualizar muestra el juego actual cuando
puede leerse; Reparar precarga sus datos y pide confirmación dentro del formulario.
Preparar conserva el juego y no solicita uno nuevo. No se conserva una selección de
juego entre operaciones.

Cancelar, Escape y X cierran el formulario antes de guardar. Durante la escritura,
espera a que termine antes de cerrar o desconectar el SSD. Los errores y el progreso
aparecen en el propio formulario. Las notificaciones no abren otra ventana mientras
está activo. Al terminar, se cierra y se actualiza la biblioteca.
