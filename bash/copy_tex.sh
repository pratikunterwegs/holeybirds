#!/bin/bash

# copy pdfs and name correctly
rm docs/ms_holeybirds_*.pdf

cp figures/fig_0*.png manuscript/figures

cd manuscript
pdflatex manuscript.tex
bibtex manuscript.aux
bibtex manuscript.aux
pdflatex manuscript.tex

cd ..

cp -p manuscript/manuscript.pdf docs/ms_holeybirds_`date -I`.pdf
