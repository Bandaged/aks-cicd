if ($IsWindows) {
  docker compose \
    --env-file ./.env,./windows.env \
    -f ./docker-compose.yml \
    -f ./docker-compose.dev.yml \
    up --build
} else {
  docker compose \
    --env-file ./.env \
    -f ./docker-compose.yml \
    -f ./docker-compose.dev.yml \
    up --build
}