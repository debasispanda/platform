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

## Keycloak Initial Setup

This repo seeds Keycloak with a default realm, client, roles, and users using import-on-startup.

- Import file: `keycloak/import/realm-platform.json`
- Realm name: `platform`
- User self-registration: enabled
- Client: `platform-web` (confidential)
- Sample users:
	- `alice` / `Alice@123` (role: `platform-admin`)
	- `bob` / `Bob@123` (role: `platform-user`)
	- `charlie` / `Charlie@123` (role: `platform-user`)

### How It Works

- Keycloak starts with `start-dev --import-realm`.
- The import directory is mounted at `/opt/keycloak/data/import`.
- The realm is imported when it does not already exist in the database.

### Realm Login Page

- Custom realm login page: http://keycloak.platform.localhost/realms/platform/account
- If you change `DOMAIN_NAME` in `.env`, update the URL to: http://keycloak.<your-domain>/realms/platform/account

### Reapply Realm Changes

If you edit `keycloak/import/realm-platform.json` after first startup, Keycloak will not overwrite an existing realm automatically.
To re-import from scratch in local development:

1. Stop the stack: `./platform.sh down`
2. Remove volumes: `docker compose down -v`
3. Start again: `./platform.sh start`

### Credential Policy by Environment

For local development, keep the seeded sample passwords in `keycloak/import/realm-platform.json` for convenience.

For production, set user credential `temporary` to `true` in the realm import so users must update passwords on first login.
Also enforce a stronger Keycloak password policy (minimum length, mixed case, number, and special character).
