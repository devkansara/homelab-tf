# Auth0 Management API — credentials from terraform/.env when sourced:
#   AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_CLIENT_SECRET
# Enable with TF_VAR_enable_auth0=true in .env or enable_auth0 in tfvars.
# Pin Management API audience — do not inherit AUTH0_AUDIENCE (Lab Monitor API JWT aud).

provider "auth0" {
  audience = "https://${var.auth0_tenant_domain}/api/v2/"
}
