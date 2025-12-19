# Script de automatización para Windows (PowerShell)
# Generador de Documentación oTree en Español (Markdown)
# Uso: .\generar_docs_espanol.ps1

# Habilitar colores en PowerShell
$Host.UI.RawUI.ForegroundColor = "White"

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

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
    Write-Host "→ Creando script de conversión..." -ForegroundColor Gray
    
    $pythonScript = @'
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
'@
    
    $pythonScript | Out-File -FilePath "convert_to_markdown.py" -Encoding UTF8
}

# Ejecutar conversión
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
