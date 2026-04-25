# Módulo de Accesos IAP y OS Login

Este módulo administra de forma centralizada quién puede conectarse a las máquinas virtuales (VMs) a través de **IAP Desktop** (Identity-Aware Proxy), aplicando estrictamente el Principio de Privilegio Mínimo.

El acceso a una VM mediante IAP se divide en dos capas de seguridad:
1. **Capa de Red (Túnel):** El permiso para alcanzar el puerto 3389 (RDP) de la máquina.
2. **Capa de Sistema Operativo:** El permiso de la cuenta de Windows (Administrador vs Usuario).

---

## 🛠 Variables Disponibles

| Variable | Descripción |
| :--- | :--- |
| `viewers` | Lista de correos. Otorga el permiso global `roles/compute.viewer`. Es **obligatorio** para que los usuarios puedan listar y ver las VMs dentro de IAP Desktop. |
| `vms` | Un diccionario que mapea el nombre exacto de la VM en GCP con sus controles de acceso. |

Dentro del bloque `vms`, cada máquina acepta las siguientes listas:
* `zone`: La zona de GCP donde vive la máquina (ej. `northamerica-south1-a`).
* `tunnel_users`: Correos de quienes pueden abrir la conexión de red hacia la VM (`roles/iap.tunnelResourceAccessor`).
* `os_admins`: Correos de quienes pueden generar credenciales locales de Administrador (`roles/compute.osAdminLogin`).
* `os_users`: Correos de quienes pueden generar credenciales locales de Usuario Estándar (`roles/compute.osLogin`).

---

## 📖 Casos de Uso y Ejemplos

Existen dos arquitecturas soportadas por este módulo. Debes elegir cómo llenar las variables dependiendo de cómo funciona la autenticación de la máquina.

### Caso 1: Máquina en Directorio Activo (AD) - Recomendado
Para servidores Windows unidos a un dominio (AD), la autenticación la maneja Microsoft, no Google Cloud. 
* **Qué hacer:** Llena solo la lista `tunnel_users` y deja las listas de OS vacías.
* **Resultado:** GCP permitirá que el usuario vea la pantalla de inicio de Windows, pero **no** le permitirá generar contraseñas locales fantasma. El usuario estará obligado a poner su contraseña del AD corporativo.

```hcl
inputs = {
  viewers = ["user:juan@csb.com"]

  vms = {
    "servidor-ad-01" = {
      zone         = "northamerica-south1-a"
      tunnel_users = ["user:juan@csb.com"] # <-- Solo abrimos el túnel
      os_admins    = []                    # <-- Vacío (Previene creación de contraseñas locales)
      os_users     = []                    # <-- Vacío
    }
  }
}
```

### Caso 2: Máquina Local (OS Login)
Para servidores aislados que no están en dominio, dependemos de Google OS Login para inyectar permisos.
* **Qué hacer:** Agrega al usuario en `tunnel_users` Y TAMBIÉN en `os_admins` o `os_users` según el nivel de privilegio que deba tener dentro de Windows.

```hcl
inputs = {
  viewers = ["user:maria@csb.com", "user:pedro@csb.com"]

  vms = {
    "servidor-aislado-01" = {
      zone         = "northamerica-south1-b"
      tunnel_users = ["user:maria@csb.com", "user:pedro@csb.com"]
      
      # Maria podrá entrar como Administradora Local e instalar software
      os_admins    = ["user:maria@csb.com"]
      
      # Pedro entrará como Usuario Estándar (solo monitoreo)
      os_users     = ["user:pedro@csb.com"]
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

> **Nota:** No necesitas que la VM exista dentro del estado de Terraform para poder darle permisos con este módulo. El módulo inyectará las políticas IAM a la VM viva basándose únicamente en su nombre y zona.
