all: Ted_Ying_Resume_Gmail.pdf Ted_Ying_Resume.pdf resume.html resume
%.pdf: %.odt
	oowriter --headless --convert-to pdf $<
%.bin.odt: %.odt
	oowriter --headless --convert-to bin.odt:writer8 $<
%.html: %.bin.odt odt.css
	./html.py $< odt.css > $@
%_Gmail.odt: %.odt
	saxon $< gmail.xsl > $@
%.ff: %.html
	./text.js $< > $@
%: %.ff
	rm -rf $@
	mkdir $@
	fontforge -script $< cmunrm.otf $@/cmunrm.otf
	fontforge -script all.ff $@/cmunrm.otf $@/cmunrm
.PHONY: all
