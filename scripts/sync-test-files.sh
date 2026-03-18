#!/bin/bash

# Sync shared test files to avoid duplication while working within kustomize security constraints
# This script copies shared configuration files to test directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[SYNC]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SYNC]${NC} $1"
}

cd "${PROJECT_ROOT}"

log_info "Syncing shared test files..."

SOURCE_WEBHOOK_PATCH="config/default/manager_webhook_patch.yaml"
E2E_WEBHOOK_PATCH="test/e2e/webhook-patch.yaml"

if [[ ! -f "$SOURCE_WEBHOOK_PATCH" ]]; then
    echo "ERROR: Source webhook patch not found: $SOURCE_WEBHOOK_PATCH"
    exit 1
fi

log_info "Syncing webhook patch to e2e test directory..."
cp "$SOURCE_WEBHOOK_PATCH" "$E2E_WEBHOOK_PATCH"

{
    echo "# AUTO-GENERATED: This file is automatically synced from $SOURCE_WEBHOOK_PATCH"
    echo "# DO NOT EDIT: Changes will be overwritten. Edit the source file instead."
    echo "#"
    cat "$E2E_WEBHOOK_PATCH"
} > "${E2E_WEBHOOK_PATCH}.tmp"
mv "${E2E_WEBHOOK_PATCH}.tmp" "$E2E_WEBHOOK_PATCH"

log_success "Webhook patch files synced successfully"
log_info "  $SOURCE_WEBHOOK_PATCH -> $E2E_WEBHOOK_PATCH"

log_success "All test files synced successfully"
