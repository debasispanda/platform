-- Create keycloak schema if it does not exist
-- All the keyloak tables will be created under this schema

CREATE SCHEMA IF NOT EXISTS keycloak AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS ${PLATFORM_SCHEMA_NAME} AUTHORIZATION postgres;
CREATE EXTENSION IF NOT EXISTS vector;
