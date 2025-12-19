# 🍎 Guía Rápida para macOS - Documentación oTree en Español

Esta es una guía específica para usuarios de Mac. Si prefieres la guía completa multiplataforma, consulta `GUIA_AUTOMATIZACION.md`.

## ⚡ Inicio Ultra-Rápido (para usuarios experimentados)

```bash
# Todo en un comando
curl -O https://raw.githubusercontent.com/oTree-org/otree-docs/master/... && \
chmod +x generar_docs_espanol.sh && \
./generar_docs_espanol.sh
```

## 📋 Pre-requisitos para Mac

### 1️⃣ Verificar si tienes Python y Git

```bash
# Abrir Terminal (⌘ + Espacio, escribir "Terminal")
python3 --version
git --version
```

**¿Ya tienes Python 3.8+ y Git?** → Salta al paso 3  
**¿No los tienes?** → Continúa con el paso 2

### 2️⃣ Instalar Python y Git (si es necesario)

#### Opción A: Usando Homebrew (Recomendado)

```bash
# 1. Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Instalar Python y Git
brew install python git

# 3. Verificar
python3 --version
git --version
pip3 --version
```

#### Opción B: Instaladores gráficos

1. **Python**: Descargar de [python.org](https://www.python.org/downloads/macos/)
2. **Git**: Descargar de [git-scm.com](https://git-scm.com/download/mac)
3. **O usar Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```

### 3️⃣ Instalar dependencias de Python

```bash
pip3 install sphinx sphinx-rtd-theme beautifulsoup4 html2text
```

**Nota**: Si `pip3` no funciona, usa:
```bash
python3 -m pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text
```

## 🚀 Ejecutar el Script de Automatización

### Método 1: Script todo-en-uno (Recomendado)

```bash
# 1. Descargar/extraer los scripts
unzip scripts_automatizacion_otree.zip
cd scripts_automatizacion_otree/

# 2. Dar permisos de ejecución
chmod +x generar_docs_espanol.sh

# 3. Ejecutar
./generar_docs_espanol.sh
```

El script hará automáticamente:
- ✅ Clonar el repositorio de oTree docs
- ✅ Compilar la documentación en español
- ✅ Convertir a Markdown
- ✅ Crear carpeta `otree-docs/docs_markdown_es/`

### Método 2: Paso a paso manual

```bash
# 1. Clonar repositorio
git clone https://github.com/oTree-org/otree-docs.git
cd otree-docs

# 2. Compilar documentación en español
python3 -m sphinx -b html -D language=es . build/html/es

# 3. Copiar script de conversión (convert_to_markdown.py)
# [Copiar el archivo convert_to_markdown.py a esta carpeta]

# 4. Convertir a Markdown
python3 convert_to_markdown.py
```

## 📂 Resultado

Después de ejecutar el script encontrarás:

```
otree-docs/
└── docs_markdown_es/          # ← Tu documentación en Markdown
    ├── admin.md
    ├── bots.md
    ├── conceptual_overview.md
    ├── currency.md
    ├── forms.md
    ├── index.md
    ├── install.md
    ├── live.md
    ├── misc/
    │   ├── advanced.md
    │   ├── bots_advanced.md
    │   ├── internationalization.md
    │   ├── intro.md
    │   ├── newconstants.md
    │   ├── noself.md
    │   ├── otreelite.md
    │   ├── rest_api.md
    │   ├── tips_and_tricks.md
    │   └── version_history.md
    ├── models.md
    ├── mturk.md
    ├── mturk_nostudio.md
    ├── multiplayer/
    │   ├── chat.md
    │   ├── groups.md
    │   ├── intro.md
    │   └── waitpages.md
    ├── otai.md
    ├── pages.md
    ├── python.md
    ├── rooms.md
    ├── rounds.md
    ├── server/
    │   ├── heroku.md
    │   ├── intro.md
    │   ├── server-windows.md
    │   └── ubuntu.md
    ├── studio.md
    ├── templates.md
    ├── timeouts.md
    ├── treatments.md
    └── tutorial/
        ├── intro.md
        ├── part1_studio.md
        ├── part2.md
        └── part3.md
```

**Total: 42 archivos Markdown en español** ✨

## 🔧 Atajos de Terminal para Mac

```bash
# Ver archivos generados
open otree-docs/docs_markdown_es/

# Buscar en todos los archivos
cd otree-docs/docs_markdown_es/
grep -r "palabra_clave" .

# Abrir un archivo específico en el editor predeterminado
open install.md

# Abrir en VS Code (si lo tienes instalado)
code .

# Ver contenido rápido de un archivo
cat index.md | less
```

## 🐛 Solución de Problemas en Mac

### Error: "command not found: python"

**Solución**: En Mac siempre usa `python3`
```bash
# ❌ Incorrecto
python convert_to_markdown.py

# ✅ Correcto
python3 convert_to_markdown.py
```

### Error: "command not found: pip"

**Solución**: Usa `pip3` o el módulo pip de Python
```bash
# Opción 1
pip3 install sphinx

# Opción 2
python3 -m pip install sphinx
```

### Error: "No module named 'sphinx'"

**Solución**: Instala con el path completo de pip
```bash
python3 -m pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text
```

### Error: "sphinx-build: command not found"

**Solución**: Usa el módulo de sphinx directamente
```bash
# En lugar de:
sphinx-build -b html -D language=es . build/html/es

# Usa:
python3 -m sphinx -b html -D language=es . build/html/es
```

### Error: "xcrun: error: invalid active developer path"

**Solución**: Instala las Command Line Tools
```bash
xcode-select --install
```

### Error de permisos: "Permission denied"

**Solución 1**: Dar permisos de ejecución
```bash
chmod +x generar_docs_espanol.sh
./generar_docs_espanol.sh
```

**Solución 2**: Ejecutar con bash explícitamente
```bash
bash generar_docs_espanol.sh
```

### El script se descarga pero no se ejecuta

**Solución**: macOS puede marcar archivos descargados como no seguros
```bash
# Remover el atributo de cuarentena
xattr -d com.apple.quarantine generar_docs_espanol.sh

# Luego ejecutar
chmod +x generar_docs_espanol.sh
./generar_docs_espanol.sh
```

### Problemas con versiones de Python (pyenv, conda, etc.)

Si usas un gestor de versiones de Python:

**pyenv**:
```bash
pyenv global 3.11.0  # o tu versión preferida
python --version
pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text
```

**conda**:
```bash
conda create -n otree python=3.11
conda activate otree
pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text
```

## 🎯 Consejos Específicos para Mac

### 1. Usar el Terminal integrado de VS Code

Si usas VS Code, puedes abrir el terminal integrado (⌘ + `) y ejecutar todos los comandos ahí.

### 2. Crear un alias para actualizar la documentación

Agrega esto a tu `~/.zshrc` o `~/.bash_profile`:

```bash
alias actualizar-otree-docs="cd ~/ruta/a/otree-docs && ./generar_docs_espanol.sh"
```

Luego solo ejecuta:
```bash
actualizar-otree-docs
```

### 3. Spotlight para buscar archivos

Después de generar los archivos, usa Spotlight (⌘ + Espacio) para buscar:
```
"conceptual_overview.md"
```

### 4. Quick Look para vista previa

Selecciona cualquier archivo `.md` en Finder y presiona **Espacio** para ver una vista previa formateada.

### 5. Automatizar con cron (Avanzado)

Para actualizar la documentación automáticamente cada mes:

```bash
# Editar crontab
crontab -e

# Agregar esta línea (actualiza el 1ro de cada mes a las 2 AM)
0 2 1 * * cd ~/ruta/a/scripts && ./generar_docs_espanol.sh >> ~/logs/otree-docs.log 2>&1
```

## 🔄 Actualizar la Documentación en el Futuro

Cuando quieras la última versión de la documentación:

```bash
# Opción 1: Ejecutar el script de nuevo
cd ruta/donde/esta/el/script
./generar_docs_espanol.sh

# Opción 2: Manual (si el repo ya existe)
cd otree-docs
git pull
python3 -m sphinx -b html -D language=es . build/html/es
python3 convert_to_markdown.py
```

## 📱 Usar en iPad/iPhone

Si quieres leer la documentación en tu iPad o iPhone:

1. Genera los archivos en tu Mac
2. Súbelos a iCloud Drive o Dropbox
3. Usa una app como [Taio](https://taio.app) o [Working Copy](https://workingcopyapp.com) para leer los Markdown

## 🎓 Para Estudiantes/Académicos

Si estás en un Mac de laboratorio universitario:

1. **Sin permisos de admin**: Usa instaladores sin sudo
   ```bash
   pip3 install --user sphinx sphinx-rtd-theme beautifulsoup4 html2text
   ```

2. **Espacio limitado**: Genera solo lo necesario
   ```bash
   # Solo el archivo que necesitas
   pandoc -f html -t gfm build/html/es/install.html -o install.md
   ```

## 💡 Integración con Herramientas de Mac

### Alfred Workflow (si usas Alfred)

Crea un workflow para buscar en la documentación:

1. Trigger: `otree {query}`
2. Action: `grep -r "{query}" ~/otree-docs/docs_markdown_es/`

### Obsidian/Notion

Importa los archivos Markdown directamente a tu sistema de notas favorito.

## ✅ Checklist Final

- [ ] Python 3.8+ instalado
- [ ] Git instalado
- [ ] Dependencias instaladas (sphinx, beautifulsoup4, html2text)
- [ ] Scripts descargados
- [ ] Permisos de ejecución dados (`chmod +x`)
- [ ] Script ejecutado correctamente
- [ ] Carpeta `docs_markdown_es/` creada con 42 archivos

---

## 🆘 ¿Sigues teniendo problemas?

1. **Lee la guía completa**: `GUIA_AUTOMATIZACION.md`
2. **Foro de oTree**: [otreehub.com/forum](https://www.otreehub.com/forum/)
3. **Verifica versiones**:
   ```bash
   python3 --version  # Debe ser 3.8+
   git --version      # Cualquier versión reciente
   ```

---

**Versión macOS**: 1.0  
**Última actualización**: Diciembre 2025  
**Compatible con**: macOS Monterey, Ventura, Sonoma (12.0+)