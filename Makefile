BIN=xf-scraper
LISP=sbcl
DEPS=:dexador :lquery
BDEPS=--load xf-scraper.asd \
      --load-system dexador \
      --load-system lquery \
      --require xf-scraper
MANIFEST=manifest.txt
MFLAGS=--no-sysinit --non-interactive \
       --eval "(ql:quickload '($(DEPS)))" \
       --eval '(ql:write-asdf-manifest-file \#P"$(MANIFEST)")' \
       --eval '(exit)'
BUILDFLAGS=--output $(BIN) \
	   --manifest-file $(MANIFEST) \
	   $(BDEPS) \
	   --entry xf-scraper:main

all: $(BIN)

$(BIN): $(MANIFEST)
	buildapp $(BUILDFLAGS)

$(MANIFEST):
	$(LISP) $(MFLAGS)

clean:
	rm -f $(BIN) $(MANIFEST)
