@REM copy pdfs and name correctly
del docs\ms_holeybirds*.pdf

cd manuscript
pdflatex manuscript.tex
bibtex manuscript.aux
pdflatex manuscript.tex
pdflatex manuscript.tex

cd ..

set mydate=%date:~10,4%_%date:~7,2%_%date:~4,2%_%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
echo %mydate%

copy manuscript\manuscript.pdf "docs\ms_holeybirds_%mydate%.pdf"

@REM copy the supplementary material to docs

del docs\ms_holeybirds_supplement*.pdf

@REM this directory not included in the repo
cd supplement-text

pdflatex supplementary-material.tex
bibtex supplementary-material.aux
pdflatex supplementary-material.tex
pdflatex supplementary-material.tex

cd ..

copy supplement-text\supplementary-material.pdf "docs\supplementary_material_holeybirds_%mydate%.pdf"
