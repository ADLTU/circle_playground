resource "google_iam_workload_identity_pool" "circleci" {
  workload_identity_pool_id = "decoder-circleci"
  display_name              = "Decoder - CircleCI"
  description               = "Identity pool for decoder CircleCI"
  project = "kraken-v2-dev"
}

resource "google_iam_workload_identity_pool_provider" "circleci" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.circleci.workload_identity_pool_id
  workload_identity_pool_provider_id = "de-coder-circleci"
  display_name                       = "Decoder CircleCI"
  description                        = "OIDC identity pool provider for decoder CircleCI"
  project = "kraken-v2-dev"
  attribute_mapping = {
    "google.subject"    = "assertion.sub"
    "attribute.aud"     = "assertion.aud"
    "attribute.project" = "assertion['oidc.circleci.com/project-id']"
  }
  oidc {
    allowed_audiences = ["12353b33-4bfb-483c-9b63-bc9489b90098"]
    issuer_uri        = "https://oidc.circleci.com/org/12353b33-4bfb-483c-9b63-bc9489b90098"
  }
}

resource "google_service_account" "circleci-service-account" {
  account_id   = "decoder-circle-ci"
  display_name = "Decoder (CircleCI) Service Account"
  description  = "Service account for CircleCI"
  project      = "kraken-v2-dev"
}

resource "google_project_iam_member" "circleci-project-member" {
  for_each = toset([
    "roles/storage.objectAdmin", # needed for Terraform to access the remote state
    "roles/iam.securityAdmin", # allows Terraform to create service accounts
    "roles/iam.serviceAccountUser", # needed for Workload Identity
    "roles/iam.workloadIdentityPoolAdmin", # allows Terraform to create/manage Workload Identity pools
    "roles/editor", # Grant the Editor role
  ])

  project = "kraken-v2-dev"
  role    = each.key
  member  = "serviceAccount:${google_service_account.circleci-service-account.email}"
}

