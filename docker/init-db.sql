-- Create keycloak schema if it does not exist
-- All the keyloak tables will be created under this schema

CREATE SCHEMA IF NOT EXISTS keycloak AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS platform AUTHORIZATION postgres;
