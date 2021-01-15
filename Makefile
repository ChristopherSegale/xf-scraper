BIN=xf-scraper
LISP=sbcl
BUNDLE=bundle
LIBS=:dexador :lquery :uiop
BNFLAGS=--no-sysinit --non-interactive \
        --eval "(ql:quickload '($(LIBS)))" \
        --eval "(ql:bundle-systems '($(LIBS)) :to \"$(BUNDLE)/\")" \
        --eval '(exit)'
BUILDFLAGS=--no-sysinit --no-userinit --non-interactive \
	   --load "$(BUNDLE)/bundle.lisp" \
	   --eval '(asdf:load-system :dexador)' \
	   --eval '(asdf:load-system :lquery)' \
	   --eval '(asdf:load-system :uiop)' \
	   --eval '(load "xf-scraper.asd")' \
	   --eval '(asdf:make :xf-scraper)'
CACHE=~/.cache/common-lisp/sbcl-$(shell sbcl --version | cut -d ' ' -f 2)-linux-x64$(shell pwd)
RM=rm -rf

all: $(BIN)

$(BIN): $(BUNDLE)
	$(LISP) $(BUILDFLAGS)

$(BUNDLE):
	$(LISP) $(BNFLAGS)

clean_all:
	rm -rf $(BIN) $(BUNDLE) $(CACHE)

clean:
	rm -f $(BIN) $(CACHE)/*.fasl
