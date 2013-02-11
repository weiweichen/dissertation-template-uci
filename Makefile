# ------------------------------------------------------------------------
# Makefile: automatic paper generation using LaTeX, dvips, etc.
# ------------------------------------------------------------------------
# written by:	Andreas Gerstlauer (based on Makefile by Rainer Doemer)
# last update:	February 25, 2004


# --- macros -------------------------------------------------------------

LATEX	=	latex
BIBTEX	=	bibtex
DVIPS	=	dvips -Z -D 600 -t letter -Ppdf
FIGPS	=	fig2dev -L ps
PSSEL	=	psselect
TAR	=	gtar cvzf
RM	=	rm -f
MV	=	mv
CAT	=	cat
GZIP	=	gzip -f
SPELL	=	nspell -t
SORT	=	sort -f
MAKEIDX	=	makeindex
DISTILL =       GS_OPTIONS="-dAutoFilterColorImages=false \
                            -dColorImageFilter=/FlateEncode" ps2pdf14
THUMBPDF=       thumbpdf --modes=dvips


PROJECT	=	dissertation

TARGETS	=	dissertation.pdf 

THUMBS	=	dissertation.tpm

SOURCES	=	 $(shell echo *.tex )

MODULES =	references.bib

#FIGURES =	FIGURES/EXAMPLE_xfig_figure.fig

#PSFIGURES =	FIGURES/EXAMPLE_xfig_figure.eps

#INCLUDES =	FIGURES/EXAMPLE_idraw_figure.idraw \
#		FIGURES/EXAMPLE_code.tex

#LISTINGS =	LISTINGS/EXAMPLE_listing.sc 	\
#		LISTINGS/EXAMPLE_listingA.sc 	\
#		LISTINGS/EXAMPLE_listingB.sc

#MACROS =        MACROS

OTHERS	=	Makefile


# --- general rules ------------------------------------------------------


.SUFFIXES:
.SUFFIXES:	.fig .prn .eps .tex .ind .idx .bbl .dvi .ps .pdf .tpm

%.eps: 	%.fig
	$(FIGPS) $*.fig $*.eps

%.eps: 	%.prn
	$(PRN2EPS) $*.prn $*.eps


%.bbl:	%.tex $(MODULES) $(PSFIGURES) $(INCLUDES) $(MACROS)
	$(LATEX) $*.tex
	$(BIBTEX) $*

%.idx %.inx:	%.tex $(MODULES) $(PSFIGURES) $(INCLUDES) $(MACROS)
	$(LATEX) $*.tex
	$(LATEX) $*.tex

%.ind:	%.idx
	$(MAKEIDX) $*

%.ps:	%.dvi $(PSFIGURES)
	$(DVIPS) $*.dvi -o $*.ps

%.pdf:	%.ps
	$(DISTILL) $*.ps

%.tpm:	%.pdf
	$(THUMBPDF) $*.pdf


# --- rules --------------------------------------------------------------

all:	$(TARGETS)


final:	$(TARGETS) $(THUMBS)
	set -e;  for t in $(THUMBS); do			\
	  BASE=`basename $$t .tpm` ; 			\
	  $(LATEX) $$BASE.tex ;				\
	  $(DVIPS) $$BASE.dvi -o $$BASE.ps ;		\
	  $(DISTILL) $$BASE.ps ;			\
	done
	$(GZIP) *.ps

new:		clean all

clean:
	$(RM) *.dvi *.ps *.ps.gz *.pdf *.tpm
	$(RM) *.toc *.lot *.lof *.lop *.log *.aux *.blg *.bbl
	$(RM) *.idx *.ind *.ilg
	$(RM) *.inx *.srt
	$(RM) *.BAK *.bak *~
	$(RM) texput.log *.out *.synctex.gz

chmod:
	chgrp -fR specc *
	chmod -fR u+rwX,g-w+rX,o-rwx *

spell:
	$(SPELL) $(MODULES)

tar:
	$(RM) book.inx ; touch book.inx
	$(TAR) $(PROJECT).tar.gz $(SOURCES) $(MODULES) $(INCLUDES) \
		$(FIGURES) $(PSFIGURES) $(LISTINGS) $(MACROS) $(OTHERS)


draft.dvi:	draft.tex draft.bbl $(MODULES) $(PSFIGURES) $(INCLUDES) $(MACROS)
	$(LATEX) draft.tex
	$(LATEX) draft.tex


dissertation.dvi:	dissertation.tex dissertation.ind dissertation.bbl $(MODULES) $(PSFIGURES) $(INCLUDES) $(MACROS) $(SOURCES)
	$(LATEX) dissertation.tex
	$(LATEX) dissertation.tex



# --- EOF ----------------------------------------------------------------
