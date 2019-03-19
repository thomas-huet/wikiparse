```
dune build --profile release wikiparse.exe
bzcat enwiki-YYYYMMDD-pages-articles.xml.bz2 | ./_build/default/wikiparse.exe | bzip2 -c > enwiki-YYYYMMDD.txt.bz2
```
