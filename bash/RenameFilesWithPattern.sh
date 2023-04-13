ls | sed -r 's/([0-9]{4}-[0-9]{2}-[0-9]{2})(.*)/mv "&" "\1 Visita Mexico -\2"/' > rename.sh

