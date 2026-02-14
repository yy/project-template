MAIN := main
SUPP := supp
COVER := cover
TEX := latexmk
MON_OPT := -pvc
CLN_OPT := -CA

.PHONY: all main-monitor supp-monitor cover cover-monitor wordcount clean

all: ${MAIN}.pdf ${SUPP}.pdf

${MAIN}.pdf:
	${TEX} ${MAIN}.tex

${SUPP}.pdf:
	${TEX} ${SUPP}.tex

${COVER}.pdf:
	${TEX} ${COVER}.tex

main-monitor:
	${TEX} ${MON_OPT} ${MAIN}.tex

supp-monitor:
	${TEX} ${MON_OPT} ${SUPP}.tex

cover: ${COVER}.pdf

cover-monitor:
	${TEX} ${MON_OPT} ${COVER}.tex

clean:
	${TEX} ${CLN_OPT} ${MAIN}.tex
	${TEX} ${CLN_OPT} ${SUPP}.tex
	${TEX} ${CLN_OPT} ${COVER}.tex

wordcount:
	detex -l -n -w ${MAIN}.tex | wc -w

