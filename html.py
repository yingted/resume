#!/usr/bin/env python2.7
from odf.odf2xhtml import ODF2XHTML
import sys

def main():
	args = sys.argv[1:]
	if len(args) != 2:
		sys.stderr.write("Usage: %s file.odt file.css\n" % sys.argv[0])
		sys.exit(2)

	reload(sys)
	sys.setdefaultencoding('utf-8')

	odt, css = args
	odt = odt.decode('utf-8')

	with open(css) as f:
		styles = f.read()

	handler = ODF2XHTML()
	generate_stylesheet = handler.generate_stylesheet
	def patched(*args, **kwargs):
		ret = generate_stylesheet(*args, **kwargs)
		handler.writeout(styles)
		return ret
	handler.generate_stylesheet = patched

	try:
		result = handler.odf2xhtml(odt).encode('us-ascii','xmlcharrefreplace')
	except:
		sys.stderr.write("Unable to open file %s or file is not OpenDocument\n" % odt)
		raise
	sys.stdout.write(result)

if __name__ == '__main__':
	main()
