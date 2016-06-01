.PHONY: build up down

build:
	docker-compose -p ci build --no-cache

up:
	docker-compose -p ci up -d

down:
	docker-compose -p ci down
