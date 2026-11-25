# Environments

Each folder here holds the settings for one environment.

- `dev/`: the development environment (learning and testing).
- `prod/`: the production environment (filled in after dev works).

Shared code lives in `stacks/` and `modules/`. These folders only hold values
for an environment, never a copy of the code.

Rules:
1. Each environment has its own state key, so dev and prod never share state.
2. No secrets in these folders. Secrets live in AWS Secrets Manager.
3. Every new stack uses S3 native locking (`use_lockfile = true`), with no lock table.
