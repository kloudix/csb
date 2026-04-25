# Módulo de Accesos IAP y OS Login

Este módulo administra de forma centralizada quién puede conectarse a las máquinas virtuales (VMs) a través de **IAP Desktop** (Identity-Aware Proxy), aplicando estrictamente el Principio de Privilegio Mínimo de forma automática.

El módulo es **súper inteligente**: no necesitas repetir el correo de las personas en varias listas. Si pones a un usuario como `os_users`, el módulo automáticamente deduce que necesita permiso para abrir el túnel de IAP y permiso para ver la VM en el proyecto. ¡Solo escribes el correo una vez!

---

## 🛠 Variables Disponibles

El archivo acepta un diccionario `vms` que mapea el nombre exacto de la VM en GCP con sus controles de acceso.

Dentro del bloque de cada máquina, tienes las siguientes opciones (puedes omitir las que no uses):
* `zone`: La zona de GCP donde vive la máquina (ej. `northamerica-south1-a`).
* `ad_users`: Correos de quienes usan **Directorio Activo**. Les abre el túnel, pero no les da permisos locales.
* `os_admins`: Correos de quienes pueden entrar como **Administrador** (OS Login).
* `os_users`: Correos de quienes pueden entrar como **Usuario Estándar** (OS Login).

---

## 📖 Casos de Uso y Ejemplos

### Caso 1: Máquina en Directorio Activo (AD) - Recomendado
Para servidores Windows unidos a un dominio (AD), la autenticación la maneja Microsoft. Solo usa la variable `ad_users`.

```hcl
inputs = {
  vms = {
    "servidor-ad-01" = {
      zone     = "northamerica-south1-a"
      ad_users = ["user:juan@csb.com"] # <-- Solo abrimos el túnel, sin contraseñas locales
    }
  }
}
```

### Caso 2: Máquina Local (OS Login)
Para servidores aislados que no están en dominio. Usa `os_admins` o `os_users`.

```hcl
inputs = {
  vms = {
    "servidor-aislado-01" = {
      zone      = "northamerica-south1-b"
      os_admins = ["user:maria@csb.com"] # Maria es Administradora
      os_users  = ["user:pedro@csb.com"] # Pedro es Usuario Estándar
    }
  }
}
```

---

## 🚀 ¿Cómo aplicar los cambios?
1. Dirígete a la carpeta del entorno y proyecto deseado (ej: `environments/csb-prod-bkaya/global/iam/iap-access/`).
2. Edita el archivo `terragrunt.hcl` agregando o quitando correos.
3. Ejecuta `terragrunt plan` para revisar los cambios.
4. Ejecuta `terragrunt apply` para inyectar los permisos.
