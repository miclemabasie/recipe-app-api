ifneq (,$(wildcard ./.env))
	include .env
	export
	ENV_FILE_PARAM = --env-file .env

endif


build:
	docker-compose up --build -d --remove-orphans

up:	
	docker-compose up -d

down:
	docker-compose down

show-logs:
	docker-compose logs


migrate:
	docker-compose exec app python manage.py migrate

makemigrations:
	docker-compose exec app python manage.py makemigrations

createsuperuser:
	docker-compose exec app python manage.py createsuperuser

collecstatic:
	docker-compose exec app python manage.py collectstatic --no-input --clear

django-check:
	docker-compose exec app python manage.py check

init_db:
	docker-compose exec app python manage.py init_db 10

shell:	
	docker-compose exec app python manage.py shell

down-v:
	docker-compose down -v 

volume:
	docker volume inspect django-real-estate_postgres_data


estate-db:
	docker-compose exec postgres-db psql -U miclem -d realestate_learn

test:
	docker-compose exec app pytest -p no:warnings --cov=.

test-html:
	docker-compose exec app pytest -p no:warnings --cov=. --cov-report html

flake8:
	docker-compose run --rm app sh -c "flake8"
	# docker-compose exec app flake8

black-check:
	docker-compose exec app black --check --exclude=migrations .

black-diff:
	docker-compose exec app black --diff --exclude=migrations .

black:
	docker-compose exec app black --exclude=migrations .

isort-check:
	docker-compose exec app isort . --check-only --skip env --skip migrations

isort-diff:
	docker-compose exec app isort . --diff --skip env --skip  migrations
	
isort:
	docker-compose exec app isort . --skip env --skip migrations

lint: 
	flake8 black-check isort-check


watch:
	docker-compose exec app watchmedo shell-command --patterns="*.py" --recursive --command='make lint test' .