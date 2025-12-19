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
