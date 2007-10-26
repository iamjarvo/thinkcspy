#-------------------------------------------------------------------------------
#
#  How to Think Like a Computer Scientist: Learning with Python  2nd Edition
#
#  make - creates xhtml book version.
#  make book - xhtml book version only.
#              No other versions are currently supported by this book's input files.
#
#-------------------------------------------------------------------------------

build:	book

book:
	mkdir -p html/
	lore -pN -b thinkCSpy.book
	mv *.html html
	cp -r illustrations html/
	cp -r resources/* html/
	tar czvf ../thinkCSpy2.tgz ../english2e
	mv ../thinkCSpy2.tgz html/

export:
	rsync -avz -e ssh --delete html/ login.ibiblio.org:thinkCSpy2/

clean:
	rm -rf html
