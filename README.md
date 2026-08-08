# ZiiiPay

ZiiiPay is a phased fintech prototype for unified simulated payments, banking, mobile money, cards, crypto and investments. The current implementation covers Phase 13: identity, simulated provider linking, financial accounts, consolidated portfolio summary, the double-entry ledger core, simulated payments, signed payment requests, display-only virtual cards, NFC/tap simulation, custodial-style crypto portfolio simulation, deterministic ZSE/VFEX investment simulation, analytics, HTML statements, notifications, controlled admin operations, security/privacy hardening, release-candidate recovery/performance artifacts and partner-integration readiness contracts. It still does not permit real value transfer.

## Stack

- Flutter mobile application in `apps/mobile`
- NestJS API in `apps/api`
- Next.js admin portal in `apps/admin-web`
- PostgreSQL and Redis through Docker Compose
- Shared contracts, design tokens, test data and configuration packages

## Prerequisites

- Node.js 22 or newer
- npm 10 or newer
- Flutter SDK 3.22 or newer
- Docker Desktop with Compose

On Windows PowerShell, use `npm.cmd` if script execution blocks `npm.ps1`.
In this workstation, Flutter has been found at `C:\Users\Ronaldo\OneDrive\Documents\flutter\bin\flutter.bat`. Docker CLI is available through Docker Desktop, but daemon access currently fails for this shell with named-pipe permission denied, so database-backed integration tests still need local Docker permission cleanup.

## Setup

```powershell
cd ziiipay
npm.cmd install
cd apps/mobile
flutter pub get
cd ../..
```

## Run

Start PostgreSQL, Redis and the API:

```powershell
docker compose up --build
```

Run services directly during development:

```powershell
npm.cmd run dev -w @ziiipay/api
npm.cmd run dev -w @ziiipay/admin-web
cd apps/mobile
flutter run
```

Health endpoints:

- API: `http://localhost:3000/health`
- Admin: `http://localhost:3001`

Phase 2 identity endpoints are simulated only:

- `POST /auth/register`
- `POST /auth/verify-otp`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `POST /auth/logout-all`
- `GET /auth/session`

Phase 3 account and portfolio endpoints are simulated only:

- `GET /providers`
- `GET /accounts`
- `POST /accounts/link`
- `DELETE /accounts/:id`
- `GET /portfolio/summary`

Phase 4 ledger endpoints are restricted to support/admin inspection only:

- `GET /admin/ledger/transactions`
- `GET /admin/ledger/transactions/:id`
- `POST /admin/ledger/reconcile`

Phase 5 payment endpoints are simulated and ledger-backed:

- `POST /payments`
- `GET /payments`
- `GET /payments/:id`
- `PATCH /payments/:id/complete`
- `PATCH /payments/:id/reverse`
- `GET /payments/:id/receipt`
- `POST /payment-requests`
- `POST /payment-requests/complete`

Phase 6 card and NFC endpoints are simulated and ledger-backed:

- `POST /cards`
- `GET /cards`
- `PATCH /cards/:id/status`
- `PATCH /cards/:id/controls`
- `POST /cards/:id/authorizations`
- `GET /cards/:id/authorizations`
- `POST /nfc/tap`

Phase 7 crypto endpoints are deterministic simulators:

- `GET /crypto/assets`
- `GET /crypto/portfolio`
- `GET /crypto/assets/:id`
- `POST /crypto/receive-addresses`
- `POST /crypto/receive`
- `POST /crypto/send`
- `POST /crypto/swap`
- `GET /crypto/transactions`
- `GET /crypto/audit`

Phase 8 investment endpoints are deterministic simulators:

- `GET /investments/instruments`
- `GET /investments/portfolio`
- `POST /investments/orders`
- `GET /investments/orders`
- `PATCH /investments/orders/:id/cancel`
- `PATCH /investments/orders/:id/fill`
- `GET /investments/audit`

Phase 9 reporting endpoints derive from simulated payments, crypto and investment sources:

- `GET /analytics/monthly-summary`
- `GET /analytics/net-worth`
- `GET /analytics/performance`
- `GET /transactions/search`
- `GET /statements/monthly`
- `GET /notifications`
- `GET /notifications/preferences`
- `PATCH /notifications/preferences`

Phase 10 admin operations endpoints are reason-captured, audited and read-mostly:

- `GET /admin/ops/users`
- `GET /admin/ops/users/:id`
- `PATCH /admin/ops/users/:id/kyc`
- `POST /admin/ops/users/:id/case-notes`
- `POST /admin/ops/users/:id/export`
- `GET /admin/ops/payments/:id`
- `GET /admin/ops/audit-events`
- `GET /admin/ops/providers/health`
- `PATCH /admin/ops/providers/:id/simulator`

Phase 11 privacy and security hardening adds redacted self-service workflows:

- `GET /privacy/export`
- `POST /privacy/account-deletion`
- `GET /privacy/account-deletion`

## Test And Verify

```powershell
npm.cmd run format:check
npm.cmd run lint
npm.cmd run test
npm.cmd run build
npm.cmd run env:validate
npm.cmd run secret:scan
npm.cmd run dependency:scan
npm.cmd run container:scan
docker compose config
k6 run infrastructure/k6/phase12-smoke.js
cd apps/mobile
flutter analyze
flutter test
flutter build web --debug
```

## Reset Local State

```powershell
docker compose down --volumes --remove-orphans
docker compose up --build
```

## Simulation Boundary

This repository starts as a high-fidelity prototype only. Do not add real money movement, real card credentials, real NFC payment credentials, cryptocurrency private keys, live market data or brokerage execution without a later approved phase and regulated provider gate.

Phase 2 authentication uses mock OTP and local/sandbox token settings. It is not production KYC, regulated identity verification or live account access.

Set `AUTH_REPOSITORY=postgres` with `DATABASE_URL` to run the Phase 2 auth module against PostgreSQL. The default `AUTH_REPOSITORY=memory` keeps tests deterministic when Docker/PostgreSQL is unavailable.

Set `ACCOUNTS_REPOSITORY=postgres` with `DATABASE_URL` to run the Phase 3 account module against PostgreSQL. The default `ACCOUNTS_REPOSITORY=memory` keeps provider/account tests deterministic while Docker Desktop is unavailable.

Set `LEDGER_REPOSITORY=postgres` with `DATABASE_URL` to run the Phase 4 ledger module against PostgreSQL. The default `LEDGER_REPOSITORY=memory` keeps invariant tests deterministic while Docker daemon access is unavailable.

Set `PAYMENT_REQUEST_SIGNING_KEY` to control the local HMAC key for simulated QR/payment-request payloads. The default example value is local only.

Phase 6 cards only expose non-sensitive display fields such as deterministic last four, status, limits and blocked merchant categories. Native NFC bridge interfaces are present for app boundaries, but production NFC/HCE/Secure Element credentials and payment tokens are disabled.

Phase 7 crypto uses deterministic asset metadata, atomic-unit quantity strings and seeded price snapshots. Receive labels, sends and swaps are simulated only; real signing, blockchain broadcast and live network adapters are disabled.

Phase 8 investments use seeded delayed ZSE/VFEX quotes, explicit exchange/currency metadata and simulated execution only. No broker connection, scraping, live quote claim or financial-advice flow is enabled.

Phase 9 analytics and statements are deterministic reporting surfaces over simulated data. Charts include textual alternatives, statement HTML avoids raw internal IDs, and notifications are deduplicated by user and event key.

Phase 10 admin operations enforce least privilege: support can search, inspect and create reasoned case notes; admin can additionally review mock KYC, control provider simulator state and generate redacted exports. Admin operations do not expose direct ledger mutation routes, and privileged changes create audit events.

Phase 11 hardening applies API body-size limits, secure headers, correlation IDs, redacted request logs and runtime allow-list validation on sensitive request bodies. Privacy export is redacted, and account deletion is a simulated request workflow that revokes sessions without deleting immutable ledger or audit history.

Phase 12 release-candidate artifacts include production-like environment validation, query-index migration `0011_performance_indexes.sql`, k6 smoke/load scenarios, backup/restore procedure, restart/retry regression tests, known limitations and a demo script. Docker daemon, k6 and Flutter/emulator execution require the local environment blockers to be resolved.

Phase 13 provider-integration readiness adds adapter specifications, local sandbox stubs, webhook signature/replay standards, reconciliation-file import contracts, kill-switch requirements, compliance/legal dependency registers and security review templates. These are governance and local-stub artifacts only; no production credentials, endpoints or live providers are enabled.

Seeded Phase 3 demo credentials:

- Email: `demo@ziiipay.local`
- Password: `DemoPass123`
- PIN: `2468`
- Mock OTP: `246810`
- Seed providers: ZiiiPay Cash, EcoCash, OneMoney, InnBucks, CBZ Bank and Steward Bank.
