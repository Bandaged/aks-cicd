if ($IsWindows) {
  docker compose --env-file ./.env,./windows.env build 
} else {
  docker compose build 
}