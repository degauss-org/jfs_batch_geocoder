build:
	docker build -t shiny_starter .

shell:
	docker run --rm -it -p 127.0.0.1:3838:3838 --entrypoint=/bin/bash shiny_starter

run:
	open "http://127.0.0.1:3838" & docker run --rm -p 3838:3838 shiny_starter 