BIN=xf-scraper
LISP=sbcl
LISPFLAGS=--no-sysinit --non-interactive
BUILDFLAGS=--load xf-scraper.asd \
		   --eval '(require :xf-scraper)' \
		   --eval '(asdf:make :xf-scraper)'

all: $(BIN)

$(BIN):
	$(LISP) $(LISPFLAGS) $(BUILDFLAGS)

clean:
	rm -f $(BIN)
