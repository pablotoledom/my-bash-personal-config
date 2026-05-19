# Environment User Configs

Configuración personal de entorno de terminal: shell, editor, fuentes y herramientas, desplegable en Debian y macOS.

![alt Terminal colors](https://raw.githubusercontent.com/pablotoledom/my-bash-personal-config/main/images/screenshot.png)

## Qué instala

- **Oh My Bash** con el tema Powerline
- **Nerd Fonts** (Hack, MesloLGS, JetBrains Mono, colección Powerline)
- **Neovim** con vim-plug y un conjunto de plugins preconfigurado
- **lsd** — reemplazo moderno de `ls` con íconos
- **bat** — `cat` con resaltado de sintaxis
- **tmux** — multiplexor de terminal
- **Bash 5** — reemplaza el Bash 3.2 del sistema en macOS
- **ble.sh** — editor de línea de Bash avanzado con autocompletado

## Características del prompt

El `.bashrc` personalizado configura el prompt Powerline con:

- Ícono del sistema operativo (Apple, Debian, Arch, Fedora, etc.)
- Rama y estado de Git con colores:
  - Verde — repositorio limpio
  - Verde brillante — cambios en stage
  - Naranja — cambios sin stage
  - Amarillo — archivos sin seguimiento
  - Rojo — conflicto de merge/rebase
- Ícono del repositorio (GitHub / Bitbucket / Git genérico)
- Paleta de color verde fósforo

## Scripts

### `install_on_debian_13.sh`

Instala el entorno en Debian 13 (probado también en Ubuntu 22).

- Instala paquetes con `apt`: neovim, bat, lsd, tmux, bash-completion, curl, git, etc.
- Instala ble.sh clonando desde GitHub y compilando
- Instala Oh My Bash desde GitHub
- Copia `copy_to_user_folder/.bashrc_debian` como `~/.bashrc`

**Requisitos:** acceso a internet, permisos `sudo`.

---

### `install_on_macos.sh`

Instala el entorno en macOS 14+ (Apple Silicon e Intel) usando Homebrew.

- Instala Homebrew si no está presente
- Instala herramientas con `brew`: neovim, bat, lsd, bash, tmux
- Instala ble.sh clonando desde GitHub y compilando
- Instala Oh My Bash desde GitHub
- Instala vim-plug desde GitHub
- Copia `copy_to_user_folder/.bashrc_macos` como `~/.bashrc`
- Crea `~/.bash_profile` para usar Bash 5 de Homebrew al iniciar sesión

**Requisitos:** acceso a internet.

---

### `install_on_macos_briked.sh`

Instala el entorno en macOS 14+ (Apple Silicon e Intel) **sin acceso a internet**. Todas las dependencias están empaquetadas en `./thirdparty/macos/`.

- Instala binarios precompilados desde `./thirdparty/macos/`: neovim, bat, lsd, tmux, bash 5
- Instala ble.sh desde un bundle `.tar.xz` local
- Instala Oh My Bash desde un bundle `.tar.gz` local
- Instala vim-plug desde el archivo `plug.vim` local
- Instala los plugins de Neovim preempaquetados en `plugged.tar.gz`
- Copia `copy_to_user_folder/.bashrc_macos` como `~/.bashrc`
- Crea `~/.bash_profile` para usar Bash 5 al iniciar sesión

**Requisitos:** sin internet. Los binarios bundleados soportan `arm64` y `x86_64`.

---

## Estructura del proyecto

```
.
├── install_on_debian_13.sh       # Instalador Debian/Ubuntu (online)
├── install_on_macos.sh           # Instalador macOS con Homebrew (online)
├── install_on_macos_briked.sh    # Instalador macOS sin internet (bundleado)
├── copy_to_user_folder/
│   ├── .bashrc_debian            # Configuración de shell para Debian/Ubuntu
│   ├── .bashrc_macos             # Configuración de shell para macOS
│   ├── .vimrc                    # Configuración de Vim
│   ├── .vim/
│   │   ├── plugins.vim           # Lista de plugins de vim-plug
│   │   └── plugged.tar.gz        # Plugins preempaquetados (uso offline)
│   └── .config/nvim/
│       └── init.vim              # Configuración de inicio de Neovim
├── fonts/
│   ├── hack/                     # Hack Nerd Font
│   ├── meslolgs/                 # MesloLGS NF
│   ├── jetbrains/                # JetBrains Mono Nerd Font
│   └── powerline/                # Colección de fuentes Powerline
├── thirdparty/macos/             # Bundles offline para macOS
└── show/
    ├── welcome                   # Banner de bienvenida
    └── divbar                    # Separador de secciones
```

## Author

**Jonathan Pablo Toledo M.**  
[TheRetroCenter.com](https://www.theretrocenter.com)
