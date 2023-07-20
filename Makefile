build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

shell:
	docker compose run app bash

shell-2:
	docker exec -it dancer2-sample bash
