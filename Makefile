SHELL := bash
FONT_PREFIX = $*-subset/
all: Ted_Ying_Resume_Gmail.pdf Ted_Ying_Resume.pdf resume.concat.html
%.pdf: %.odt
	soffice --headless --convert-to pdf $<
%.bin.odt: %.odt
	soffice --headless --convert-to bin.odt:writer8 $<
%.html: %.bin.odt odt.css
	./html.py $< odt.css > $@
%_Gmail.odt: %.odt
	saxon $< gmail.xsl > $@
%.ff: %.html
	./text.js $< > $@
%-subset: %.ff
	rm -rf $@
	mkdir $@
	fc-list 'CMU Serif' file | cut -d: -f1 | while read font;\
	do\
		base="$${font##*/}";\
		fontforge -script $< "$$font" $@/"$$base";\
		fontforge -script all.ff $@/"$$base" $@/"$${base%.*}";\
	done
%.concat.html: %.bin.odt odt.css %-subset
	./html.py $< <(cat odt.css; ./concat.py $* $(FONT_PREFIX)) > $@
clean:
	git clean -fxd
.PHONY: all clean
