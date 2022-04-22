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
