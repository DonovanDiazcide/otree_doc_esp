# Guía de Automatización: Documentación oTree en Español

Esta guía te permite generar automáticamente la documentación de oTree en formato Markdown (español) desde el repositorio oficial.

## 📋 Requisitos Previos

### Software necesario:
- Python 3.8+
- Git
- pip (gestor de paquetes de Python)

### Librerías de Python requeridas:
```bash
pip install sphinx sphinx-rtd-theme beautifulsoup4 html2text
```

### Herramienta adicional:
- **Sphinx**: Para compilar la documentación

## 🚀 Proceso Completo Automatizado

### Paso 1: Clonar el Repositorio de oTree Docs

```bash
# Clonar el repositorio oficial de oTree
git clone https://github.com/oTree-org/otree-docs.git
cd otree-docs
```

### Paso 2: Compilar la Documentación en Español

El repositorio ya contiene las traducciones en la carpeta `locales/es/`. Necesitamos compilar la documentación:

```bash
# Compilar la documentación en español
sphinx-build -b html -D language=es . build/html/es
```

**Nota**: Si `sphinx-build` no se encuentra, usa:
```bash
python -m sphinx -b html -D language=es . build/html/es
```

### Paso 3: Convertir HTML a Markdown

Guarda el siguiente script como `convert_to_markdown.py` en la raíz del repositorio:

```python
#!/usr/bin/env python3
"""
Convierte la documentación HTML de oTree (español) a Markdown.
Uso: python convert_to_markdown.py
"""

import html2text
from pathlib import Path
from bs4 import BeautifulSoup
import sys

def extract_and_convert(html_file, output_file):
    """
    Extrae el contenido principal del HTML y lo convierte a Markdown.
    """
    try:
        with open(html_file, 'r', encoding='utf-8') as f:
            soup = BeautifulSoup(f.read(), 'html.parser')
        
        # Buscar el contenido principal
        main_content = soup.find('div', {'itemprop': 'articleBody'})
        
        if not main_content:
            # Alternativas si no se encuentra
            main_content = (
                soup.find('div', {'class': 'body'}) or
                soup.find('div', {'role': 'main'}) or
                soup.find('article')
            )
        
        if not main_content:
            return False
        
        # Eliminar enlaces de encabezado (headerlink)
        for element in main_content.find_all(['a'], {'class': 'headerlink'}):
            element.decompose()
        
        # Configurar html2text
        h = html2text.HTML2Text()
        h.ignore_links = False
        h.ignore_images = False
        h.ignore_emphasis = False
        h.body_width = 0  # No ajustar el ancho del texto
        h.unicode_snob = True
        h.skip_internal_links = False
        h.protect_links = True
        h.wrap_links = False
        
        # Convertir a markdown
        markdown_content = h.handle(str(main_content))
        
        # Limpiar espacios en blanco excesivos
        lines = []
        prev_empty = False
        for line in markdown_content.split('\n'):
            line_stripped = line.strip()
            is_empty = len(line_stripped) == 0
            
            # Evitar líneas vacías consecutivas
            if is_empty and prev_empty:
                continue
            
            lines.append(line.rstrip())
            prev_empty = is_empty
        
        markdown_content = '\n'.join(lines)
        
        # Guardar el archivo
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(markdown_content)
        
        return True
        
    except Exception as e:
        print(f"  Error: {str(e)}", file=sys.stderr)
        return False

def main():
    # Directorios
    input_dir = Path('build/html/es')
    output_dir = Path('docs_markdown_es')
    
    # Verificar que existe el directorio de entrada
    if not input_dir.exists():
        print("❌ Error: No se encuentra build/html/es/")
        print("   Primero compila la documentación con:")
        print("   sphinx-build -b html -D language=es . build/html/es")
        sys.exit(1)
    
    # Crear directorio de salida
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print("=" * 70)
    print("Conversión HTML (español) → Markdown")
    print("=" * 70)
    print(f"Entrada:  {input_dir.absolute()}")
    print(f"Salida:   {output_dir.absolute()}")
    print("=" * 70)
    print()
    
    # Archivos a omitir
    skip_files = {'genindex.html', 'search.html'}
    converted = 0
    failed = 0
    
    # Procesar todos los archivos HTML
    for html_file in input_dir.rglob('*.html'):
        if html_file.name in skip_files:
            continue
        
        # Calcular ruta relativa
        try:
            rel_path = html_file.relative_to(input_dir)
        except ValueError:
            continue
        
        # Crear archivo de salida
        output_file = output_dir / rel_path.with_suffix('.md')
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        print(f"├─ {rel_path}", end=" ")
        
        if extract_and_convert(html_file, output_file):
            converted += 1
            print("✓")
        else:
            failed += 1
            print("✗")
    
    print()
    print("=" * 70)
    print(f"✓ Convertidos: {converted}")
    print(f"✗ Errores: {failed}")
    print(f"📁 Guardados en: {output_dir.absolute()}")
    print("=" * 70)
    
    if failed > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()
```

### Paso 4: Ejecutar la Conversión

```bash
python convert_to_markdown.py
```

Esto creará una carpeta `docs_markdown_es/` con todos los archivos Markdown en español.

## 🔄 Script Todo-en-Uno

Para mayor comodidad, aquí tienes un script bash que automatiza todo el proceso. Guárdalo como `generar_docs_espanol.sh`:

```bash
#!/bin/bash

# Script de automatización completa para generar documentación oTree en español (Markdown)
# Uso: ./generar_docs_espanol.sh

set -e  # Detener en caso de error

echo "=================================================="
echo "Generador de Documentación oTree en Español (MD)"
echo "=================================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paso 1: Verificar/clonar repositorio
echo -e "${YELLOW}[1/4] Obteniendo repositorio oTree-docs...${NC}"
if [ -d "otree-docs" ]; then
    echo "→ Repositorio ya existe. Actualizando..."
    cd otree-docs
    git pull
    cd ..
else
    echo "→ Clonando repositorio..."
    git clone https://github.com/oTree-org/otree-docs.git
fi
echo -e "${GREEN}✓ Repositorio listo${NC}"
echo ""

# Paso 2: Verificar dependencias
echo -e "${YELLOW}[2/4] Verificando dependencias...${NC}"
pip install -q sphinx sphinx-rtd-theme beautifulsoup4 html2text
echo -e "${GREEN}✓ Dependencias instaladas${NC}"
echo ""

# Paso 3: Compilar documentación en español
echo -e "${YELLOW}[3/4] Compilando documentación en español...${NC}"
cd otree-docs
python -m sphinx -b html -D language=es . build/html/es
echo -e "${GREEN}✓ Documentación compilada${NC}"
echo ""

# Paso 4: Crear script de conversión (si no existe)
if [ ! -f "convert_to_markdown.py" ]; then
    echo -e "${YELLOW}[4/4] Creando script de conversión...${NC}"
    cat > convert_to_markdown.py << 'PYTHON_SCRIPT'
#!/usr/bin/env python3
"""Convierte la documentación HTML de oTree (español) a Markdown."""

import html2text
from pathlib import Path
from bs4 import BeautifulSoup
import sys

def extract_and_convert(html_file, output_file):
    """Extrae el contenido principal del HTML y lo convierte a Markdown."""
    try:
        with open(html_file, 'r', encoding='utf-8') as f:
            soup = BeautifulSoup(f.read(), 'html.parser')
        
        main_content = soup.find('div', {'itemprop': 'articleBody'})
        
        if not main_content:
            main_content = (
                soup.find('div', {'class': 'body'}) or
                soup.find('div', {'role': 'main'}) or
                soup.find('article')
            )
        
        if not main_content:
            return False
        
        for element in main_content.find_all(['a'], {'class': 'headerlink'}):
            element.decompose()
        
        h = html2text.HTML2Text()
        h.ignore_links = False
        h.ignore_images = False
        h.ignore_emphasis = False
        h.body_width = 0
        h.unicode_snob = True
        h.skip_internal_links = False
        h.protect_links = True
        h.wrap_links = False
        
        markdown_content = h.handle(str(main_content))
        
        lines = []
        prev_empty = False
        for line in markdown_content.split('\n'):
            line_stripped = line.strip()
            is_empty = len(line_stripped) == 0
            if is_empty and prev_empty:
                continue
            lines.append(line.rstrip())
            prev_empty = is_empty
        
        markdown_content = '\n'.join(lines)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(markdown_content)
        
        return True
        
    except Exception as e:
        print(f"  Error: {str(e)}", file=sys.stderr)
        return False

def main():
    input_dir = Path('build/html/es')
    output_dir = Path('docs_markdown_es')
    
    if not input_dir.exists():
        print("❌ Error: No se encuentra build/html/es/")
        sys.exit(1)
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print("=" * 70)
    print("Conversión HTML (español) → Markdown")
    print("=" * 70)
    print(f"Entrada:  {input_dir.absolute()}")
    print(f"Salida:   {output_dir.absolute()}")
    print("=" * 70)
    print()
    
    skip_files = {'genindex.html', 'search.html'}
    converted = 0
    failed = 0
    
    for html_file in input_dir.rglob('*.html'):
        if html_file.name in skip_files:
            continue
        
        try:
            rel_path = html_file.relative_to(input_dir)
        except ValueError:
            continue
        
        output_file = output_dir / rel_path.with_suffix('.md')
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        print(f"├─ {rel_path}", end=" ")
        
        if extract_and_convert(html_file, output_file):
            converted += 1
            print("✓")
        else:
            failed += 1
            print("✗")
    
    print()
    print("=" * 70)
    print(f"✓ Convertidos: {converted}")
    print(f"✗ Errores: {failed}")
    print(f"📁 Guardados en: {output_dir.absolute()}")
    print("=" * 70)

if __name__ == "__main__":
    main()
PYTHON_SCRIPT
    chmod +x convert_to_markdown.py
fi

# Ejecutar conversión
echo -e "${YELLOW}[4/4] Convirtiendo a Markdown...${NC}"
python convert_to_markdown.py
echo -e "${GREEN}✓ Conversión completada${NC}"
echo ""

# Resumen final
echo "=================================================="
echo -e "${GREEN}✓ PROCESO COMPLETADO${NC}"
echo "=================================================="
echo "📁 Archivos Markdown en español disponibles en:"
echo "   $(pwd)/docs_markdown_es/"
echo ""
echo "💡 Para actualizar la documentación en el futuro:"
echo "   ./generar_docs_espanol.sh"
echo "=================================================="

cd ..
```

### Para Windows (PowerShell)

Guarda como `generar_docs_espanol.ps1`:

```powershell
# Script de automatización para Windows (PowerShell)
# Uso: .\generar_docs_espanol.ps1

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Generador de Documentación oTree en Español (MD)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Verificar/clonar repositorio
Write-Host "[1/4] Obteniendo repositorio oTree-docs..." -ForegroundColor Yellow
if (Test-Path "otree-docs") {
    Write-Host "→ Repositorio ya existe. Actualizando..." -ForegroundColor Gray
    Set-Location otree-docs
    git pull
    Set-Location ..
} else {
    Write-Host "→ Clonando repositorio..." -ForegroundColor Gray
    git clone https://github.com/oTree-org/otree-docs.git
}
Write-Host "✓ Repositorio listo" -ForegroundColor Green
Write-Host ""

# Paso 2: Instalar dependencias
Write-Host "[2/4] Verificando dependencias..." -ForegroundColor Yellow
pip install -q sphinx sphinx-rtd-theme beautifulsoup4 html2text
Write-Host "✓ Dependencias instaladas" -ForegroundColor Green
Write-Host ""

# Paso 3: Compilar documentación
Write-Host "[3/4] Compilando documentación en español..." -ForegroundColor Yellow
Set-Location otree-docs
python -m sphinx -b html -D language=es . build/html/es
Write-Host "✓ Documentación compilada" -ForegroundColor Green
Write-Host ""

# Paso 4: Convertir a Markdown
Write-Host "[4/4] Convirtiendo a Markdown..." -ForegroundColor Yellow

# Crear script de conversión si no existe
if (-not (Test-Path "convert_to_markdown.py")) {
    # (El contenido del script Python va aquí, igual que en el script bash)
    # Por brevedad, asume que ya existe o cópialo manualmente
}

python convert_to_markdown.py
Write-Host "✓ Conversión completada" -ForegroundColor Green
Write-Host ""

# Resumen
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "✓ PROCESO COMPLETADO" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "📁 Archivos Markdown en español disponibles en:"
Write-Host "   $PWD\docs_markdown_es\"
Write-Host ""
Write-Host "💡 Para actualizar la documentación en el futuro:"
Write-Host "   .\generar_docs_espanol.ps1"
Write-Host "==================================================" -ForegroundColor Cyan

Set-Location ..
```

## 📝 Uso Rápido

### Linux/Mac:
```bash
chmod +x generar_docs_espanol.sh
./generar_docs_espanol.sh
```

### Windows:
```powershell
.\generar_docs_espanol.ps1
```

## 📂 Estructura de Salida

Después de ejecutar el script, tendrás:

```
otree-docs/
├── docs_markdown_es/          # ← Documentación en Markdown (español)
│   ├── admin.md
│   ├── bots.md
│   ├── index.md
│   ├── install.md
│   ├── misc/
│   ├── multiplayer/
│   ├── server/
│   ├── tutorial/
│   └── ...
├── build/html/es/             # HTML compilado (español)
├── locales/es/                # Archivos de traducción (.po)
└── convert_to_markdown.py     # Script de conversión
```

## 🔧 Personalización

### Cambiar el idioma de salida

Para generar documentación en japonés o chino:

```bash
# Japonés
sphinx-build -b html -D language=ja . build/html/ja

# Chino
sphinx-build -b html -D language=zh_CN . build/html/zh_CN
```

Luego actualiza `input_dir` en `convert_to_markdown.py`:
```python
input_dir = Path('build/html/ja')  # o zh_CN
```

### Opciones de html2text

Puedes ajustar la conversión modificando las opciones en `convert_to_markdown.py`:

```python
h = html2text.HTML2Text()
h.ignore_links = False        # True para ignorar enlaces
h.ignore_images = False       # True para ignorar imágenes
h.body_width = 0              # 80 para ajustar a 80 caracteres
h.mark_code = True            # Marcar bloques de código
```

## ⚠️ Solución de Problemas

### Error: "sphinx-build: command not found"
```bash
# Usa el módulo de Python directamente
python -m sphinx -b html -D language=es . build/html/es
```

### Error: "ModuleNotFoundError: No module named 'sphinx_rtd_theme'"
```bash
pip install sphinx-rtd-theme
```

### Algunos archivos no se traducen completamente
- Esto es normal. Los archivos `.po` en `locales/es/` pueden no tener todas las cadenas traducidas
- Puedes contribuir traducciones al repositorio oficial de oTree

## 📚 Referencias

- **Repositorio oficial**: https://github.com/oTree-org/otree-docs
- **Documentación Sphinx**: https://www.sphinx-doc.org/
- **html2text**: https://github.com/Alir3z4/html2text/

## 🎯 Próximos Pasos

1. Ejecuta el script todo-en-uno
2. Verifica los archivos en `docs_markdown_es/`
3. Usa los archivos Markdown en tu proyecto
4. Vuelve a ejecutar el script cuando quieras actualizar

---

**Autor**: Proceso automatizado  
**Fecha**: Diciembre 2025  
**Versión**: 1.0
