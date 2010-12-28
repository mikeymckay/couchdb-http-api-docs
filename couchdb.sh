#! /bin/env bash

function check_dependencies() {
    found=1
    if ! type -P "rdiscount" &> /dev/null
    then
        echo "Please install the 'rdiscount' gem."
        found=0
    fi
    if ! type -P "ebook-convert" &> /dev/null
    then
        echo "Please install the 'calibre' e-book library application."
        found=0
    fi
    if (( found == 0 ))
    then
        usageexit
        exit 1
    fi
}

function usageexit() {
    echo "Usage: ./$(basename $0) [LANG]"
    echo "  Convert the CouchDB http API docs to MOBI format"
    exit 1
}

check_dependencies

language=${1:-'en'}

html=couchdb-$language.html
mobi=couchdb-$language.mobi

HTML_HEADER='<html xmlns="http://www.w3.org/1999/xhtml">\n
<head>\n
\t<title>CouchDB HTTP API Docs</titl\n
\t<link rel="stylesheet" href="couchdb.css" type="text/css" media="all" />
</head>\n
<body>\n'
HTML_FOOTER='</body>\n</html>\n'

chapters=$(find . -type f -name "*.markdown" | sort)

echo -e $HTML_HEADER > $html
for chapter in $chapters
do
    echo "Converting $chapter"
    rdiscount $chapter >> $html
done
echo -e $HTML_FOOTER >> $html

ebook-convert $html $mobi \
--cover "apache-couchdb.png" \
--authors "Lena Herrmann" \
--title "CouchDB HTTP API Docs" \
--comments "licensed under the Creative Commons Attribution-Non Commercial-Share Alike 3.0 license" \
--extra-css "mobi.css" \
--language "$language" \
--level1-toc "//h:h1" \
--level2-toc "//h:h2" \
--level3-toc "//h:h3"
