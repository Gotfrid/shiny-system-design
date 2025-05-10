[doc("Build all docker images")]
build:
	docker buildx bake

[doc("Start authentication stack")]
start-auth:
	docker compose -f compose.authentication.yml up
