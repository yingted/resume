all: Ted_Ying_Résumé_Gmail.pdf Ted_Ying_Résumé.pdf
%.pdf: %.odt
	oowriter --headless --convert-to pdf $<
%_Gmail.odt: %.odt
	saxon $< gmail.xsl > $@
