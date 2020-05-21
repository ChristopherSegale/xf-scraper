(asdf:defsystem "xf-scraper"
  :author "Christopher Segale"
  :license "MIT"
  :depends-on (:dexador
               :lquery)
  :components ((:file "xf-scraper"))
  :build-operation "program-op"
  :build-pathname "xf-scraper"
  :entry-point "xf-scraper:main")
