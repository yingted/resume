all: Ted_Ying_Resume_Gmail.pdf Ted_Ying_Resume.pdf resume.html
%.pdf: %.odt
	oowriter --headless --convert-to pdf $<
%.bin.odt: %.odt
	xml2odf -o $@ $<
%.html: %.bin.odt
	./html.py $< odt.css > $@
%_Gmail.odt: %.odt
	saxon $< gmail.xsl > $@
.PHONY: all
