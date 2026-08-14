MAIN := main
SUPP := supp
COVER := cover

.PHONY: all main supp cover monitor main-monitor supp-monitor cover-monitor wordcount clean

all: main supp

main:
	latexmk -pdf $(MAIN).tex

supp:
	latexmk -pdf $(SUPP).tex

cover:
	latexmk -pdf $(COVER).tex

monitor: main-monitor

main-monitor:
	latexmk -pvc -pdf $(MAIN).tex

supp-monitor:
	latexmk -pvc -pdf $(SUPP).tex

cover-monitor:
	latexmk -pvc -pdf $(COVER).tex

clean:
	latexmk -CA $(MAIN).tex
	latexmk -CA $(SUPP).tex
	latexmk -CA $(COVER).tex

wordcount:
	detex -l -n -w $(MAIN).tex | wc -w
