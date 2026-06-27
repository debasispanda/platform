#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"
ENV_FILE="$SCRIPT_DIR/.env"
COMPOSE_CMD=(docker compose -f "$COMPOSE_FILE")
SERVICES=(postgres keycloak)

usage() {
	cat <<'EOF'
Usage:
	./platform.sh <command> [service]

Commands:
	start [service]   Start all services or a single service
	stop [service]    Stop all services or a single service
	restart [service] Restart all services or a single service
	status [service]  Show the status of all services or a single service
	logs <service>    Follow logs for a single service
	exec <service>    Open a shell in a running service container
	down              Remove the full stack
	help              Show this help message

Options:
	-h, --help        Show this help message

Services:
	postgres
	keycloak
EOF
}

die() {
	echo "$1" >&2
	exit 1
}

load_env() {
	if [[ -f "$ENV_FILE" ]]; then
		set -a
		# shellcheck disable=SC1090
		source "$ENV_FILE"
		set +a
	fi
}

is_valid_service() {
	local service_name="$1"
	local known_service
	for known_service in "${SERVICES[@]}"; do
		if [[ "$known_service" == "$service_name" ]]; then
			return 0
		fi
	done
	return 1
}

require_service() {
	local action_name="$1"
	local service_name="$2"
	[[ $# -eq 2 ]] || die "$action_name requires exactly one service name"
	is_valid_service "$service_name" || die "Unknown service: $service_name"
}

load_env

if [[ $# -eq 0 ]]; then
	usage
	exit 0
fi

case "$1" in
	-h|--help|help)
		usage
		exit 0
		;;
	start)
		shift
		if [[ $# -eq 0 ]]; then
			"${COMPOSE_CMD[@]}" up -d
		else
			"${COMPOSE_CMD[@]}" up -d "$1"
		fi
		;;
	stop)
		shift
		if [[ $# -eq 0 ]]; then
			"${COMPOSE_CMD[@]}" stop
		else
			is_valid_service "$1" || die "Unknown service: $1"
			"${COMPOSE_CMD[@]}" stop "$1"
		fi
		;;
	restart)
		shift
		if [[ $# -eq 0 ]]; then
			"${COMPOSE_CMD[@]}" restart
		else
			is_valid_service "$1" || die "Unknown service: $1"
			"${COMPOSE_CMD[@]}" restart "$1"
		fi
		;;
	status)
		shift
		if [[ $# -eq 0 ]]; then
			"${COMPOSE_CMD[@]}" ps
		else
			is_valid_service "$1" || die "Unknown service: $1"
			"${COMPOSE_CMD[@]}" ps "$1"
		fi
		;;
	down)
		shift
		[[ $# -eq 0 ]] || die "down does not take a service name"
		"${COMPOSE_CMD[@]}" down
		;;
	logs)
		shift
		require_service logs "$1"
		"${COMPOSE_CMD[@]}" logs -f "$1"
		;;
	exec)
		shift
		require_service exec "$1"
		"${COMPOSE_CMD[@]}" exec "$1" sh
		;;
	*)
		die "Unknown command: $1"
		;;
esac
