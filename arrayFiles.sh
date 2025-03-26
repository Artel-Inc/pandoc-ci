#!/bin/sh

for arg in "$@"
do
	FILE=$arg; 
	FILE_OUTPUT="${arg%.*}.pdf"; 

	if [ ! -f "$FILE" ]; then
	    echo "$FILE not found!"
	    continue;
	fi
	
	if [ -z "$OUTPUT" ]; then
		OUTPUT="."
	fi
	
	FILE_OUTPUT=$OUTPUT/$FILE_OUTPUT; 
	mkdir -p `dirname $FILE_OUTPUT`
	
	echo "Сompilation: $FILE -> $FILE_OUTPUT"
	
	if [ "$HEADERRIGHT" == "git" ]; then
		HEADERRIGHT="Commit: `git log --date=format:'%Y%m%d%H' --pretty=tformat:"%h [%cd]" $FILE | head -n1`"
	fi
	
	if [ "$CHANGELOG" == "true" ]; then
		cp $FILE ${FILE}.orig
		echo "" >>  $FILE;
		echo "\newpage" >>  $FILE;
		echo "## Changelog" >>  $FILE;
		echo "|Commit|Date|Comment|" >>  $FILE;
		echo "|-|-|-|" >>  $FILE;
		git log  --date=format:'%Y%m%d%H' --pretty=tformat:"|%h|[%cd]|%s|" $FILE >> $FILE;
	fi

	FILE=`realpath $FILE`
	FILE_OUTPUT=`realpath $FILE_OUTPUT`

	cd `dirname $FILE`
	/usr/local/bin/pandoc \
	--pdf-engine=lualatex --template eisvogel --highlight-style pygments --variable table-use-row-colors=true --variable footnotes-pretty=true \
	--variable listings-no-page-break=true  --variable toc-own-page=true --variable header-right="$HEADERRIGHT" $FILE -o $FILE_OUTPUT
	cd -

	if [ "$CHANGELOG" == "true" ]; then
		mv $FILE.orig ${FILE}
	fi
done
