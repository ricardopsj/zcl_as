# zcl_as — Utilidades del Application Server

Utilidades para interactuar con el servidor de aplicaciones SAP. Hoy contiene la ejecución de comandos del sistema operativo.

```abap
data: lt_salida type zcl_as=>tyt_string.

data(lv_rc) = zcl_as=>execute( exporting cmd = 'ls -l /usr/sap/trans'
                               importing rsl = lt_salida ).
if lv_rc <> 0.
  " el comando no se pudo ejecutar
endif.
```

## Instalación

Importar con [abapGit](https://abapgit.org). Requiere ABAP 7.40 o superior. Sin dependencias de otros paquetes Z.

## API

| Método | Descripción |
|---|---|
| `execute( cmd ) → src` | Ejecuta `cmd` en el sistema operativo del servidor de aplicaciones con la llamada de kernel `CALL 'SYSTEM'`. Devuelve `SY-SUBRC` y entrega la salida del comando en `rsl` (una línea por elemento, hasta 2048 caracteres cada una) |
| `tyt_string` | Tipo tabla de `string` para la salida |

La clase también tiene el método privado `get_kernel_version`, que lee la versión del kernel con `CALL 'SAPCORE'`. Hoy no se usa ni se expone.

## Seguridad

`execute` ejecuta **cualquier** comando con el usuario del sistema operativo del servidor SAP (`<sid>adm`), sin chequeo de autorización. Quien pueda llamar a la clase puede leer, modificar o borrar archivos del servidor.

- Limitar su uso a programas que tengan su propio chequeo de autorización.
- Nunca construir `cmd` con datos ingresados por el usuario.
- Para comandos de uso productivo, preferir comandos externos definidos en la transacción SM69 y ejecutados con `SXPG_COMMAND_EXECUTE`, que tienen control de autorización (`S_LOG_COM`) y parámetros acotados.

`CALL 'SYSTEM'` es una llamada de kernel no liberada por SAP. El sistema puede tenerla deshabilitada con el parámetro de perfil `rdisp/call_system`.
