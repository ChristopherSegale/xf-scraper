BIN=xf-scraper
LISP=sbcl
BUNDLE=bundle
LIBS=:dexador :lquery
BNFLAGS=--no-sysinit --non-interactive \
        --eval "(ql:quickload '($(LIBS)))" \
        --eval "(ql:bundle-systems '($(LIBS)) :to \"$(BUNDLE)/\")" \
        --eval '(exit)'
BUILDFLAGS=--no-sysinit --no-userinit --non-interactive \
	   --load "$(BUNDLE)/bundle.lisp" \
	   --eval '(asdf:load-system :dexador)' \
	   --eval '(asdf:load-system :lquery)' \
	   --eval '(load "xf-scraper.asd")' \
	   --eval '(asdf:make :xf-scraper)'

all: $(BIN)

$(BIN): $(BUNDLE)
	$(LISP) $(BUILDFLAGS)

bundle:
	$(LISP) $(BNFLAGS)

clean_all:
	rm -rf $(BIN) $(BUNDLE)

clean:
	rm -f $(BIN)
