SHELL := bash
FONT_PREFIX = $%/
all: Ted_Ying_Resume_Gmail.pdf Ted_Ying_Resume.pdf
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
	fc-list 'CMU Serif' file | cut -d: -f1 | while read font;\
	do\
		base="$${font##*/}";\
		fontforge -script $< "$$font" $@/"$$base";\
		fontforge -script all.ff $@/"$$base" $@/"$${base%.*}";\
	done
%.concat.html: %.bin.odt odt.css %
	./html.py $< <(cat odt.css; ./concat.py $* $(FONT_PREFIX)) > $@
.PHONY: all
