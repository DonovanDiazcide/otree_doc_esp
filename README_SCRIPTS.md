# Scripts de Automatización - Documentación oTree en Español

Este paquete contiene todos los scripts necesarios para generar automáticamente la documentación de oTree en formato Markdown (español).

## 📦 Contenido del Paquete

```
├── GUIA_AUTOMATIZACION.md      # Guía completa y detallada
├── README_SCRIPTS.md            # Este archivo (inicio rápido)
├── generar_docs_espanol.sh      # Script completo para Linux/Mac
├── generar_docs_espanol.ps1     # Script completo para Windows
└── convert_to_markdown.py       # Script de conversión Python
```

## 🚀 Inicio Rápido

### Linux / Mac

```bash
# 1. Dar permisos de ejecución
chmod +x generar_docs_espanol.sh

# 2. Ejecutar
./generar_docs_espanol.sh
```

### Windows (PowerShell)

```powershell
# Ejecutar directamente
.\generar_docs_espanol.ps1
```

## ✨ ¿Qué hace el script?

1. **Clona/actualiza** el repositorio oficial de oTree docs
2. **Instala** las dependencias necesarias (Sphinx, BeautifulSoup, html2text)
3. **Compila** la documentación HTML en español
4. **Convierte** los archivos HTML a Markdown limpio
5. **Genera** la carpeta `docs_markdown_es/` con 42 archivos .md

## 📋 Requisitos

- Python 3.8+
- Git
- pip (gestor de paquetes de Python)

**El script instala automáticamente estas librerías:**
- sphinx
- sphinx-rtd-theme
- beautifulsoup4
- html2text

## 📂 Resultado

Después de ejecutar el script tendrás:

```
otree-docs/
└── docs_markdown_es/
    ├── admin.md
    ├── bots.md
    ├── index.md
    ├── install.md
    ├── misc/
    │   ├── advanced.md
    │   ├── tips_and_tricks.md
    │   └── ...
    ├── multiplayer/
    ├── server/
    ├── tutorial/
    └── ...
```

## 🔄 Actualizar la Documentación

Simplemente ejecuta el script de nuevo. Automáticamente:
- Descargará los últimos cambios del repositorio
- Recompilará la documentación
- Regenerará los archivos Markdown

## 📖 Para Más Información

Lee `GUIA_AUTOMATIZACION.md` para:
- Explicación detallada del proceso
- Opciones de personalización
- Solución de problemas
- Generar documentación en otros idiomas (japonés, chino)

## ⚡ Uso Manual (Sin el Script Automático)

Si prefieres ejecutar cada paso manualmente:

```bash
# 1. Clonar repositorio
git clone https://github.com/oTree-org/otree-docs.git
cd otree-docs

# 2. Instalar dependencias
pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text

# 3. Compilar documentación
python -m sphinx -b html -D language=es . build/html/es

# 4. Convertir a Markdown
python convert_to_markdown.py
```

## 🎯 Casos de Uso

- **Documentación offline**: Lee la documentación sin conexión
- **Integración en proyectos**: Incluye la documentación en tus repositorios
- **Búsqueda rápida**: Usa grep/find para buscar en los archivos .md
- **Control de versiones**: Mantén versiones específicas de la documentación
- **Traducciones personalizadas**: Edita y mejora las traducciones

## 💡 Tips

- Ejecuta el script cada mes para tener la documentación actualizada
- Los archivos Markdown son compatibles con GitHub, GitLab, VS Code, etc.
- Puedes convertir los .md a PDF usando pandoc si lo necesitas

## 🐛 Problemas Comunes

### "sphinx-build: command not found"
Usa: `python -m sphinx` en lugar de `sphinx-build`

### "ModuleNotFoundError"
Ejecuta: `pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text`

### Algunos textos aparecen en inglés
Es normal. Los archivos de traducción (.po) pueden estar incompletos.

## 📞 Soporte

- **Documentación oTree**: https://otree.readthedocs.io/
- **Repositorio oficial**: https://github.com/oTree-org/otree-docs
- **Foro oTree**: https://www.otreehub.com/forum/

---

**¿Primera vez?** → Usa el script automático (`generar_docs_espanol.sh` o `.ps1`)  
**¿Necesitas personalizar?** → Lee `GUIA_AUTOMATIZACION.md`  
**¿Solo conversión HTML→MD?** → Usa `convert_to_markdown.py`
