[doc("Build all docker images")]
build:
	docker buildx bake

[doc("Start authentication stack")]
start:
	docker compose up
