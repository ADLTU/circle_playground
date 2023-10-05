output "circleci-service-account" {
  value = google_service_account.circleci-service-account.email
}

output "workload-identity-pool" {
  value = google_iam_workload_identity_pool.circleci.id
}

output "workload-identity-pool-provider" {
  value = google_iam_workload_identity_pool_provider.circleci.id
}
