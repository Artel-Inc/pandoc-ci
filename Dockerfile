FROM pandoc/extra:latest-alpine
COPY templates/eisvogel.latex /.pandoc/templates/eisvogel.latex
COPY templates/lastpage.sty /opt/texlive/texdir/texmf-dist/tex/luatex/lastpage.sty
RUN texhash

RUN apk add --no-cache git
COPY arrayFiles.sh /opt/arrayFiles.sh
ENTRYPOINT ["/opt/arrayFiles.sh"]
