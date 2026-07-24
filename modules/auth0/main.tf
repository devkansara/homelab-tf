terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.14"
    }
  }
}

resource "auth0_resource_server" "lab_api" {
  name        = "Lab Monitor API"
  identifier  = var.api_audience
  signing_alg = "RS256"

  allow_offline_access                            = true
  skip_consent_for_verifiable_first_party_clients = true
  token_lifetime                                  = 10800
}

resource "auth0_resource_server_scopes" "lab_api" {
  resource_server_identifier = auth0_resource_server.lab_api.identifier

  scopes {
    name        = "read:status"
    description = "Read ops topology and health"
  }

  scopes {
    name        = "read:logs"
    description = "Read container logs"
  }

  scopes {
    name        = "read:ops"
    description = "Broad ops read"
  }
}

resource "auth0_client" "lab_spa" {
  name                = "Lab Monitor SPA"
  app_type            = "spa"
  callbacks           = var.callbacks
  allowed_logout_urls = var.logout_urls
  allowed_origins     = var.allowed_origins
  web_origins         = var.web_origins
  oidc_conformant     = true
  grant_types         = ["authorization_code", "refresh_token"]

  refresh_token {
    rotation_type   = "rotating"
    expiration_type = "expiring"
    token_lifetime  = 2592000
  }
}

resource "auth0_client_grant" "spa_api" {
  client_id = auth0_client.lab_spa.id
  audience  = auth0_resource_server.lab_api.identifier
  scopes    = ["read:status", "read:logs", "read:ops"]
}

data "auth0_connection" "database" {
  name = "Username-Password-Authentication"
}

resource "auth0_connection_clients" "lab_spa_database" {
  connection_id = data.auth0_connection.database.id
  enabled_clients = distinct(concat(
    var.extra_database_connection_client_ids,
    compact([var.auth0_m2m_client_id]),
    [auth0_client.lab_spa.id, data.auth0_client.default_app.id],
  ))
}
