# Here's where we'll put our Make commands
directories:
	-mkdir tmp
	-mkdir data

downloads:
	curl "https://www.imf.org/external/datamapper/api/v1/PCPIPCH?periods=2023" -o tmp/inflation.json
	curl "https://www.imf.org/external/datamapper/api/v1/countries" -o tmp/countries.json

freshdata:
	node imf_to_csv.js

all: directories downloads freshdata filecheck

filecheck:
		curl "https://s3.amazonaws.com/ktanner-data-public/inflation-map/inflation.csv/" -o  tmp/previous.csv

		cmp --silent ./tmp/previous.csv ./data/inflation.csv || \
		curl -X POST -H 'Content-type: application/json' \
		--insecure \
		--data '{"text":"The file you asked me to watch has changed!"}' $$SLACK_WEBHOOK

