# UPV/EHU · HEFA — Plantilla Quarto + Typst para TFG / GRAL

[![Bertsioa / Versión](https://img.shields.io/badge/bertsioa-v1.1.0-5FD790?style=for-the-badge&logo=semver&logoColor=white)](https://github.com)
[![Quarto](https://img.shields.io/badge/Quarto-%3E%3D1.9-blue?style=for-the-badge&logo=quarto&logoColor=white)](https://quarto.org)
[![Typst](https://img.shields.io/badge/Typst-0.11+-239dad?style=for-the-badge&logo=typst&logoColor=white)](https://typst.app)
[![HEFA - UPV/EHU](https://img.shields.io/badge/HEFA-UPV%2FEHU-black?style=for-the-badge)](https://www.ehu.eus/hefa)

> **Bertsioa / Versión:** `v1.1.0` (2026ko azaroa / Noviembre 2026)  
> **Mantenedor / Egilea:** HEFA (UPV/EHU)  
> **Lizentzia / Licencia:** MIT  

Plantilla académica oficial para la redacción y maquetación de **Trabajos Fin de Grado (TFG / GRAL)** en la **Facultad de Educación, Filosofía y Antropología (HEFA)** de la Universidad del País Vasco / Euskal Herriko Unibertsitatea (UPV/EHU).

Desarrollada como **libro Quarto** (`project: type: book`) con **[Quarto](https://quarto.org/)** y el motor de maquetación tipográfica de última generación **[Typst](https://typst.app/)**, combina la sencillez de Markdown con la velocidad de compilación instantánea y la calidad tipográfica de nivel imprenta, integrando una **guía didáctica y metodológica interactiva paso a paso**.

---

## Novedades y características principales

- **Libro Quarto en tres formatos:**
  - **PDF (Typst):** documento oficial único `build/urtea-abizena-izena-eu.pdf` con la portada HEFA.
  - **HTML:** libro web multipágina (`build/index.html`), una página por capítulo, con barra lateral, buscador y iconos blancos de descarga del PDF y del DOCX al pie de la barra lateral (definidos en `book.sidebar.footer` y con estilo en `templates/html/hefa.scss`). Si cambias `book.output-file`, actualiza también esos dos enlaces.
  - **DOCX:** documento Word único `build/urtea-abizena-izena-eu.docx` para la revisión con el tutor/a, con la **misma maquetación que el PDF**: portada HEFA, preliminares sin cabecera, índice tras los resúmenes, capítulos en página impar, cabeceras pares/impares con el capítulo, numeración exterior, rótulos y tablas APA 7. Al abrirlo, Word pregunta si actualizar los campos: responde **Sí** para generar el índice y las cabeceras (o pulsa F9).
- **Web con identidad EHU:** logotipo de HEFA en la barra lateral (fondo UNIBERDEA), tipografía EHUSans servida como fuente web, enlaces en verde oscuro accesible, pie de página con título y autor/a, rótulos y tablas según APA 7 (`templates/html/hefa.scss`).
- **Estructura modular:** `index.qmd` es la página de inicio y reúne las secciones preliminares (portada, eskerrak, laburpenak, aurkibidea). Los 8 capítulos se registran en `_quarto.yml` → `book.chapters` y cada uno empieza automáticamente en página impar en el PDF.
- **Sin la plantilla "orange-book":** Quarto aplica por defecto a los libros Typst la plantilla *orange-book* (portada, índice y títulos de capítulo propios). La plantilla la sustituye mediante los parciales de `templates/typst/partials/`, de modo que mandan `hefa-cover.typ` y `hefa-style.typ`.
- **Guía metodológica y rúbrica integrada (`.callout-note`):** Cada sección y subsección incluye cuadros orientativos con:
  - **Edukia:** Contenido exacto exigido por la normativa HEFA.
  - **Luzera orientagarria:** Porcentajes orientativos de extensión respecto al volumen total de la memoria.
  - **Aditz-denborak (APA 7):** Tiempos verbales reglamentarios para cada sección (presente, pasado, etc.).
  - **Galdera orientagarriak:** Preguntas disparadoras para estructurar la argumentación.
  - **Adibideak:** Ejemplos contextualizados de redacción científica en educación.
  - **Aipu bibliografikoak:** Indicador de citas requeridas, recomendadas o no aplicables.
- **Portada institucional HEFA idéntica al modelo oficial:** Reproduce con exactitud la plantilla reglamentaria (`docs/reference/gral-portada.docx`), con el logotipo oficial de alta resolución, versalitas adaptadas a `EHUSans`, filetes en verde institucional y pie de secretaría oficial.
- **Identidad corporativa EHU (Manual de Marca 2026):** Aplicación coherente del color institucional principal **UNIBERDEA (`#5FD790`)** y la paleta completa oficial (*Lurra, Egurra, Zerua, Egunsentia, Argia, Behe-lainoa*).
- **Tipografía corporativa:** Familia tipográfica **EHUSans** (archivos OTF en `assets/fonts/`) cargadas directamente desde `assets/fonts/` al compilar el PDF.
- **Metadatos centralizados (`_quarto.yml`):** Cambias el título, subtítulo, autor/a, NAN/DNI, grado, director/a, departamento, curso y convocatoria en un solo lugar y se propagan automáticamente a la portada, cabeceras dinámicas y firmas de anexos.
- **Secciones preliminares normalizadas:**
  - `front-matter/azala.qmd`: Carga de portada e ingesta reactiva de metadatos.
  - `front-matter/eskerrak.qmd`: Agradecimientos formateados con estilo preliminar (`#prelim-heading`).
  - `front-matter/laburpenak.qmd`: Resúmenes trilingües obligatorios (**Euskera / Laburpena**, **Castellano / Resumen**, **Inglés / Abstract**) con palabras clave según tesauros normalizados (UNESCO / ERIC).
  - `front-matter/aurkibidea.qmd`: Índice general dinámico (`Aurkibidea`) con reinicio controlado de foliación.
- **Sistema avanzado de encabezados y pies de página alternos:**
  - **Páginas pares:** Título del capítulo activo a la izquierda y `Gradu Amaierako Lana (GRAL)` a la derecha; folio visible exterior en el pie izquierdo.
  - **Páginas impares (inicio de capítulo):** `Gradu Amaierako Lana (GRAL)` a la izquierda y Nombre del autor/a a la derecha; folio visible exterior en el pie derecho.
  - **Páginas impares (continuación):** `Gradu Amaierako Lana (GRAL)` a la izquierda y Título del capítulo a la derecha; folio visible exterior en el pie derecho.
  - Divisor superior continuo con filete en verde corporativo `UNIBERDEA`.
- **Cumplimiento estricto de APA 7.ª edición:**
  - **Tablas científicas:** Título superior (Número en negrita, título en cursiva), filetes horizontales (1 pt superior e inferior, 0.5 pt bajo cabecera; sin líneas verticales), celdas numéricas y de texto sin justificar para evitar huecos artificiales, y notas al pie con `#taula-oharra[...]`.
  - **Figuras y diagramas:** Cabecera superior APA 7, numeración correlativa continua. Soporte nativo para diagramas vectoriales en **Mermaid** y **Graphviz**.
  - **Citas textuales en bloque (> 40 palabras):** Sangría de 0.5 cm, cuerpo de letra a 10 pt, interlineado simple y filete lateral en verde corporativo.
  - **Bibliografía automatizada:** Ingesta BibTeX con Pandoc Citeproc (`bibliography/references.bib`), estilo APA 7 (`bibliography/apa.csl`) y citas interactivas clickables (`link-citations: true`).
- **Anexos obligatorios completos (`08-eranskinak.qmd`):**
  - Declaración y justificación del uso ético de **Inteligencia Artificial Generativa (IA / AA)**.
  - Compromiso ético y protección de datos (baimen informatuak, anonimotasuna).
  - Espacio para instrumentos de recogida, guiones de entrevista, cronogramas y matrices de análisis.

---

## Estructura del repositorio

```text
├── _quarto.yml                  # Configuración del libro: metadatos, capítulos (book.chapters) y formatos
├── index.qmd                    # Página de inicio: incluye las secciones preliminares de front-matter/
├── README.md                    # Esta guía de uso
├── AGENTS.md · HANDOFF.md       # Instrucciones y traspaso para asistentes IA (en inglés)
├── .gitignore                   # Excluye build/, .quarto/ y ficheros intermedios
├── front-matter/                # Secciones preliminares (sin numerar), incluidas desde index.qmd
│   ├── azala.qmd                # Portada Typst y helper #prelim-heading
│   ├── eskerrak.qmd             # Eskerrak / Agradecimientos
│   ├── laburpenak.qmd           # Laburpena, Resumen, Abstract + gako-hitzak
│   └── aurkibidea.qmd           # Índice general y cabeceras/pies de página dinámicos
├── chapters/                    # Capítulos numerados (registrados en book.chapters)
│   ├── 01-sarrera.qmd           # 1. Sarrera / Introducción
│   ├── 02-marko.qmd             # 2. Marko teorikoa / Marco teórico
│   ├── 03-metodo.qmd            # 3. Metodoa / Metodología
│   ├── 04-emaitzak.qmd          # 4. Emaitzak / Resultados
│   ├── 05-eztabaida.qmd         # 5. Eztabaida / Discusión
│   ├── 06-ondorioak.qmd         # 6. Ondorioak / Conclusiones
│   ├── 07-erreferentziak.qmd    # 7. Erreferentziak (contenedor {#refs})
│   └── 08-eranskinak.qmd        # 8. Eranskinak / Anexos
├── templates/html/
│   ├── hefa.scss                # Tema HEFA de la web: EHUSans, colores, barra lateral, APA 7
│   └── caption-labels.html      # Script para rótulos APA (etiqueta en negrita) en la web
├── templates/filters/           # Filtros Lua comunes (PDF y Word)
│   ├── keep-with-next.lua       # Subtítulos en negrita (**Así**) unidos al bloque siguiente
│   └── apa-references.lua       # Sangría francesa APA en la lista de referencias del PDF
├── templates/docx/              # Maquetación del Word
│   ├── hefa-reference.docx      # Plantilla de estilos, página y cabeceras (generada)
│   ├── build-reference-docx.py  # Script que genera la plantilla (solo si cambias estilos)
│   └── hefa-docx.lua            # Filtro: portada, índice, saltos, rótulos y tablas APA
├── templates/typst/             # Maquetación del PDF
│   ├── hefa-style.typ           # Reglas Typst: tipografía, títulos, APA 7, callouts y paleta EHU
│   ├── hefa-cover.typ           # Portada oficial HEFA (lee los metadatos de _quarto.yml)
│   └── partials/                # Sustituyen a la plantilla orange-book de Quarto (NO borrar)
│       ├── typst-show.typ       #   configuración mínima del documento, sin portada ni índice
│       ├── page.typ             #   A4 y márgenes HEFA
│       └── numbering.typ        #   numeración continua APA 7 de figuras y tablas
├── bibliography/
│   ├── references.bib           # Base de datos bibliográfica BibTeX
│   └── apa.csl                  # Estilo de citación APA 7.ª edición
├── assets/
│   ├── images/                  # Logotipo institucional e imágenes del trabajo
│   └── fonts/                   # Fuentes corporativas EHUSans y EHUSerif (OTF)
├── docs/reference/              # Documentación oficial de consulta (no se compila)
│   ├── guia-hefa.pdf            # Normativa HEFA del GRAL
│   ├── guia-marca-ehu.pdf       # Manual de marca UPV/EHU 2026
│   └── gral-portada.docx        # Modelo oficial de portada en Word
└── build/                       # Salida generada: PDF, DOCX y libro HTML (no editar)
```

---

## Guía rápida de uso

### 1. Configurar los metadatos de tu trabajo

Abre `_quarto.yml` y edita la sección `metadata.tfg` con los datos de tu Trabajo Fin de Grado:

```yaml
metadata:
  tfg:
    titulua: "IRAKASLE-IDENTITATEAREN ERAIKUNTZA ETA METODOLOGIA BERRITZAILEAK LEHEN HEZKUNTZAN"
    azpititulua: "Hezkuntza Proiektu berritzaile baten azterketa eta esku-hartze proposamena"
    egilea: "Ane Garcia Goikoetxea"
    nan: "12345678Z"
    gradua: "Lehen Hezkuntzako Gradua"
    zuzendaria: "Daniel Losada Iglesias, dk."
    saila: "Didaktika eta Eskola Antolakuntza Saila"
    ikasturtea: "2026/2027"
    deialdia: "2026/2027 Ikasturtea - Ohiko deialdia (Ekaina)"
```

> **Propagación automática:** estos datos se propagan a la portada oficial y a las cabeceras de página del PDF. El título, subtítulo y autor/a se reutilizan además en la sección `book:` mediante anclas YAML (`&titulua` / `*titulua`), así que **no hay que escribirlos dos veces**. Conserva las anclas (`&titulua`, `&azpititulua`, `&egilea`) al editar.

#### Personalizar el nombre de los ficheros de salida (`output-file`)

En un libro Quarto, el nombre del PDF y del DOCX se define **sin extensión** en la sección `book:`:

```yaml
book:
  output-file: "urtea-abizena-izena-eu"   # → build/urtea-abizena-izena-eu.pdf y .docx
```

#### Añadir, quitar o reordenar capítulos

Los capítulos se registran en `_quarto.yml` (no en `index.qmd`):

```yaml
book:
  chapters:
    - index.qmd                     # página de inicio (secciones preliminares)
    - chapters/01-sarrera.qmd
    - chapters/02-marko.qmd
    # ...
```

Cada fichero de capítulo debe empezar por un único título de nivel 1 (`# SARRERA {#sec-sarrera}`). En el PDF, ese título empieza en página impar, lleva el filete verde UNIBERDEA y aparece en las cabeceras de página.

> **No borres** el título `# Atariko atalak {#sec-atariko-atalak ...}` de `index.qmd`: Quarto necesita un título por fichero y, si falta, toma el primer encabezado ("Eskerrak") y lo coloca antes de la portada. En el PDF este título está oculto; en la web y el Word agrupa las secciones preliminares.

---

### 2. Cómo trabajar con los capítulos y la guía didáctica

Cada capítulo en la carpeta `chapters/` está listo para ser editado. Al abrir cualquier capítulo, encontrarás bloques explicativos como este:

```markdown
::: {.callout-note}
## Edukia: Sarrera

Ikerketaren aurkezpena, testuingurua eta justifikazioa...

**Luzera orientagarria:** Lan osoaren % 10–15 (% 12 inguru).
**Aditz-denborak (APA 7):** Oraina, nagusiki.
**Aipu bibliografikoak:** Gomendagarriak dira, eta normalean nahitaezkoak 1.1 eta 1.2 azpiataletan.
:::
```

#### Flujo de redacción recomendado:
1. **Consulta la guía:** Lee las indicaciones, preguntas sugeridas, tiempos verbales y porcentajes recomendados antes de escribir.
2. **Redacta tu texto:** Escribe tu contenido en Markdown estándar justo debajo de las llamadas o sustituyendo los párrafos de relleno `{{< lipsum ... >}}`.
3. **Versión final para depósito:** Cuando tengas el texto consolidado y vayas a generar la versión final definitiva para entregar en secretaría, puedes eliminar o comentar los bloques `::: {.callout-note}` para que el documento final contenga únicamente tu texto académico.

---

### 3. Redacción científica: citas, tablas, figuras y diagramas

#### Citas bibliográficas (APA 7)
Agrega tus entradas bibliográficas en `bibliography/references.bib` y cítalas en el texto:
- **Cita parentética:** `[@anderson2001]` $\rightarrow$ *(Anderson et al., 2001)*
- **Cita narrativa:** `@carrington2016` $\rightarrow$ *Carrington (2016)*
- **Múltiples autores:** `[@bisquerra2019; @bolivar2020]`
- Todas las citas son hipervínculos navegables directamente hacia la bibliografía final al final del documento.
- **Solo aparecen en `chapters/07-erreferentziak.qmd` las referencias citadas en el texto** (norma APA). La plantilla incluye citas de ejemplo en Sarrera, Marko teorikoa y Metodoa (`@ainscow2020`, `@booth2011`, `@creswell2018`, `@hernandez2018`, `@braun2006`, `@onu2015`); sustitúyelas por las tuyas.

#### Tablas en formato APA 7 con notas explicativas
Escribe las tablas en Markdown convencional y añade notas con el comando Typst `#taula-oharra[...]`:

```markdown
| Fasea | Jarduera nagusiak | Denboralizazioa |
|:------|:------------------|:----------------|
| 1. Diagnostikoa | Ikasgelako behaketa eta elkarrizketak | Urria - Azaroa |
| 2. Diseinua | Esku-hartze didaktikoaren diseinua | Abendua - Urtarrila |
| 3. Garapena | Ikasgelako inplementazioa | Otsaila - Apirila |
| 4. Ebaluazioa | Datuen bilketa eta triangulazioa | Maiatza |

: Ikerketaren garapen-faseak eta denboralizazio orokorra. {#tbl-kronograma}

```{=typst}
#taula-oharra[Ikastetxeko zuzendaritzarekin eta irakasleekin adostutako behin-betiko egutegia.]
```
```

#### Figuras e ilustraciones
Inserta las figuras asegurando un título descriptivo y la etiqueta de referencia `#fig-...`:

```markdown
![Esku-hartze didaktikoaren eredu pedagogikoa eta dimentsioak.](/assets/images/eredua.png){#fig-eredua}
```

En el texto puedes referenciarla usando `@fig-eredua`. La plantilla colocará automáticamente el rótulo y título en la parte superior según las directrices de APA 7.

#### Diagramas de flujo y mapas conceptuales nativos (Mermaid)
Quarto compila diagramas de **Mermaid** directamente como gráficos vectoriales nítidos:

````markdown
```{mermaid}
%%| label: fig-faseak
%%| fig-cap: "Ikerketaren fase metodologikoen sekuentziazioa eta fluxua."
%%| fig-width: 5.8
%%| fig-align: center

flowchart LR
  A[1. Diagnostikoa] --> B[2. Diseinua]
  B --> C[3. Garapena]
  C --> D[4. Ebaluazioa]

  style A fill:#EEECE9,stroke:#5FD790,stroke-width:1.5px
  style B fill:#EEECE9,stroke:#5FD790,stroke-width:1.5px
  style C fill:#B0FBC1,stroke:#5FD790,stroke-width:1.5px
  style D fill:#EEECE9,stroke:#5FD790,stroke-width:1.5px
```
````

#### Cajas de reflexión ética y compromisos ODS / JGH
Para reflexiones sobre los Objetivos de Desarrollo Sostenible (JGH / ODS) o avisos metodológicos relevantes, puedes usar los Callouts de Quarto o el bloque corporativo Typst:

```markdown
::: {.callout-tip}
## Garapen Jasangarrirako Helburuekiko (JGH / ODS) lotura eta konpromiso etikoa

Lan honek Garapen Jasangarrirako Helburuekin (JGH) lotura zuzena du:
- **4. JGH: Kalitatezko hezkuntza.** Hezkuntza inklusiboa, bidezkoa eta kalitatezkoa bermatzea da lanaren ardatza...
:::
```

*(O de forma equivalente con la función Typst `#kutxa-nabarmena(titulua: [...])[...]`).*

---

### 4. Paleta de colores oficial UPV/EHU (Guía 2026)

Para ilustraciones, esquemas o gráficos personalizados, se recomienda emplear la paleta institucional:

| Color | Código HEX | Simbolismo y uso recomendado |
|:---|:---|:---|
| **UNIBERDEA** | `#5FD790` | Verde corporativo principal (identidad, sostenibilidad y futuro). |
| **BERDE LEUNA** | `#B0FBC1` | Aprendizaje, reflexión conceptual y claridad didáctica. |
| **LURRA** | `#EEECE9` | Neutro cálido de fondo para cajas destacadas y llamadas. |
| **EGURRA** | `#B1AB9F` | Neutro de contraste para bordes y filetes secundarios. |
| **ZERUA** | `#7E8EFE` | Azul cielo: rigor científico, investigación y metodología. |
| **EGUNSENTIA** | `#FE8B66` | Alborada: trabajo en equipo, comunidad y cooperación. |
| **ARGIA** | `#E4F568` | Luz: innovación pedagógica, dinamismo y creatividad. |
| **BEHE LAINOA** | `#C6ACF5` | Niebla: sensibilidad, equilibrio y vida universitaria. |

---

## Compilación del documento

Ejecuta los comandos desde la raíz del proyecto (**no** compiles `index.qmd` suelto: el libro necesita todo el proyecto):

```bash
# Todos los formatos (PDF + DOCX + HTML)
quarto render

# Solo el PDF oficial (build/urtea-abizena-izena-eu.pdf)
quarto render --to typst

# Solo el Word (build/urtea-abizena-izena-eu.docx)
quarto render --to docx

# Solo el libro web (build/index.html)
# ¡Ojo! Borra el PDF y el DOCX de build/, así que los botones de descarga
# de la web darán error 404 hasta que vuelvas a ejecutar `quarto render`.
quarto render --to html

# Previsualización web con recarga automática
quarto preview
```

---

## Convenciones para contribuir

- **Comentarios siempre en inglés:** todos los comentarios de los ficheros del proyecto (`_quarto.yml`, ficheros `.typ`, bloques Typst y comentarios `<!-- -->` dentro de los `.qmd`) se escriben en inglés. El contenido del trabajo (texto, títulos, leyendas y cuadros de guía) se mantiene en euskera.
- Las instrucciones detalladas para asistentes IA y colaboradores están en `AGENTS.md`.

---

## Publicación en GitHub Pages

El repositorio incluye `.github/workflows/publish.yml`. En cada `push` a la rama `main`, GitHub Actions instala Quarto, compila los tres formatos y publica `build/` en **https://danloi2.github.io/gral-info/** (libro web con botones de descarga del PDF y del Word). También se puede lanzar a mano desde la pestaña *Actions* → *Publish to GitHub Pages* → *Run workflow*.

---

## Requisitos del sistema e instalación de fuentes

1. **Quarto CLI:** Versión 1.9 o superior (probado con 1.10.20) ([quarto.org](https://quarto.org/)).
2. **Typst:** Incluido automáticamente en las distribuciones recientes de Quarto (no requiere instalación independiente).
3. **Instalación de las fuentes corporativas:**
   Para obtener la tipografía oficial idéntica al modelo institucional, instala las fuentes contenidas en la carpeta `assets/fonts/` (`EHUSans` y `EHUSerif`):
   - **Linux:** Copia los archivos `.otf` a `~/.local/share/fonts/` y ejecuta `fc-cache -f`.
   - **macOS:** Abre los archivos `.otf` con la aplicación *Catálogo Tipográfico* (Font Book) e instálalos.
   - **Windows:** Selecciona los archivos `.otf`, haz clic derecho y elige *Instalar para todos los usuarios*.
   *(Para el PDF no es imprescindible: `_quarto.yml` indica `font-paths: assets/fonts`, así que Typst usa directamente las fuentes de la carpeta `assets/fonts/`. Instalarlas sí es necesario para ver EHUSans en el Word).*
