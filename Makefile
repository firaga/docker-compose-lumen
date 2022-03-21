composer core:
	docker-compose run --rm composer install -d ./eeo_core_business
composer lms:
	docker-compose run --rm composer install -d ./lms
start:
	docker-compose up -d site
restart:
	docker-compose down
	docker-compose up -d site
test:
	echo "hello"
buildNginx:
	docker-compose build nginx