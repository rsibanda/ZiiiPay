# Contributing

Development is phase-gated. Before changing code, read `CODEX.md`, the blueprint phase scope and the latest report in `docs/testing`.

## Required Flow

1. Run the current baseline checks.
2. Make phase-scoped changes only.
3. Add or update tests with the implementation.
4. Run formatting, lint, tests, builds and the phase-specific gate.
5. Record exact commands and results in `docs/testing/phase-XX-report.md`.

Do not commit secrets, real customer data, production provider endpoints, card credentials, crypto keys or live market data.
