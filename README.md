# platform
Ready to use platform for enterprise applications

## CLI

Use `./platform.sh` from the repository root to manage the stack.

Commands:

- `./platform.sh start` starts all services
- `./platform.sh start postgres` starts a single service
- `./platform.sh stop` stops all services
- `./platform.sh stop keycloak` stops a single service
- `./platform.sh restart [service]` restarts the stack or one service
- `./platform.sh status [service]` shows container status for the stack or one service
- `./platform.sh logs <service>` follows logs for a single service
- `./platform.sh exec <service>` opens a shell in a single service container
- `./platform.sh down` removes the full stack
- `./platform.sh -h` or `--help` prints the available commands

The script loads `.env` from the repository root before invoking Docker Compose.
`.env` is ignored by git, so copy `.env.template` to `.env` and adjust the values locally.
