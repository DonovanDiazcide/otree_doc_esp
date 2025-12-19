#!/usr/bin/env python3
"""
Convierte la documentación HTML de oTree (español) a Markdown.

Este script extrae el contenido principal de los archivos HTML generados por Sphinx
y los convierte a formato Markdown limpio.

Requisitos:
    - beautifulsoup4
    - html2text

Uso:
    python convert_to_markdown.py
    
El script espera encontrar los archivos HTML en: build/html/es/
Y generará los archivos Markdown en: docs_markdown_es/
"""

import html2text
from pathlib import Path
from bs4 import BeautifulSoup
import sys

def extract_and_convert(html_file, output_file):
    """
    Extrae el contenido principal del HTML de Sphinx y lo convierte a Markdown.
    
    Args:
        html_file (Path): Ruta al archivo HTML de entrada
        output_file (Path): Ruta al archivo Markdown de salida
        
    Returns:
        bool: True si la conversión fue exitosa, False en caso contrario
    """
    try:
        # Leer el archivo HTML
        with open(html_file, 'r', encoding='utf-8') as f:
            soup = BeautifulSoup(f.read(), 'html.parser')
        
        # Buscar el contenido principal usando diferentes selectores
        # Sphinx usa 'itemprop="articleBody"' para el contenido principal
        main_content = soup.find('div', {'itemprop': 'articleBody'})
        
        if not main_content:
            # Intentar con selectores alternativos
            main_content = (
                soup.find('div', {'class': 'body'}) or
                soup.find('div', {'role': 'main'}) or
                soup.find('article')
            )
        
        if not main_content:
            print(f"  ⚠ No se encontró contenido principal", file=sys.stderr)
            return False
        
        # Eliminar elementos no deseados (enlaces de encabezado)
        for element in main_content.find_all(['a'], {'class': 'headerlink'}):
            element.decompose()
        
        # Configurar html2text para una conversión óptima
        h = html2text.HTML2Text()
        h.ignore_links = False          # Mantener enlaces
        h.ignore_images = False         # Mantener imágenes
        h.ignore_emphasis = False       # Mantener énfasis (negrita, cursiva)
        h.body_width = 0                # No ajustar el ancho del texto
        h.unicode_snob = True           # Usar caracteres Unicode cuando sea apropiado
        h.skip_internal_links = False   # Mantener enlaces internos
        h.protect_links = True          # Proteger URLs de ser modificadas
        h.wrap_links = False            # No ajustar enlaces
        
        # Convertir HTML a Markdown
        markdown_content = h.handle(str(main_content))
        
        # Limpiar el contenido: eliminar líneas vacías excesivas
        lines = []
        prev_empty = False
        
        for line in markdown_content.split('\n'):
            line_stripped = line.strip()
            is_empty = len(line_stripped) == 0
            
            # Saltar múltiples líneas vacías consecutivas
            if is_empty and prev_empty:
                continue
            
            lines.append(line.rstrip())
            prev_empty = is_empty
        
        markdown_content = '\n'.join(lines)
        
        # Guardar el archivo Markdown
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(markdown_content)
        
        return True
        
    except Exception as e:
        print(f"  Error: {str(e)}", file=sys.stderr)
        return False

def main():
    """
    Función principal que coordina la conversión de todos los archivos HTML.
    """
    # Directorios de entrada y salida
    input_dir = Path('build/html/es')
    output_dir = Path('docs_markdown_es')
    
    # Verificar que existe el directorio de entrada
    if not input_dir.exists():
        print("❌ Error: No se encuentra el directorio build/html/es/")
        print()
        print("Asegúrate de haber compilado la documentación primero:")
        print("  sphinx-build -b html -D language=es . build/html/es")
        print()
        print("O usa el módulo de Python:")
        print("  python -m sphinx -b html -D language=es . build/html/es")
        sys.exit(1)
    
    # Crear directorio de salida si no existe
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Mostrar información del proceso
    print("=" * 70)
    print("Conversión HTML (español) → Markdown")
    print("=" * 70)
    print(f"Entrada:  {input_dir.absolute()}")
    print(f"Salida:   {output_dir.absolute()}")
    print("=" * 70)
    print()
    
    # Archivos HTML a omitir (páginas de índice y búsqueda)
    skip_files = {'genindex.html', 'search.html'}
    
    # Contadores
    converted = 0
    failed = 0
    
    # Procesar todos los archivos HTML recursivamente
    for html_file in input_dir.rglob('*.html'):
        # Omitir archivos especiales
        if html_file.name in skip_files:
            continue
        
        # Calcular la ruta relativa
        try:
            rel_path = html_file.relative_to(input_dir)
        except ValueError:
            continue
        
        # Crear la ruta de salida correspondiente
        output_file = output_dir / rel_path.with_suffix('.md')
        
        # Crear subdirectorios si es necesario
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Mostrar progreso
        print(f"├─ {rel_path}", end=" ")
        
        # Convertir el archivo
        if extract_and_convert(html_file, output_file):
            converted += 1
            print("✓")
        else:
            failed += 1
            print("✗")
    
    # Mostrar resumen final
    print()
    print("=" * 70)
    print(f"✓ Archivos convertidos exitosamente: {converted}")
    if failed > 0:
        print(f"✗ Archivos con errores: {failed}")
    print(f"📁 Archivos guardados en: {output_dir.absolute()}")
    print("=" * 70)
    
    # Salir con código de error si hubo fallos
    if failed > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()
