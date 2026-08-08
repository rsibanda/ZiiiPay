# ZiiiPay Codex Rules

You are developing ZiiiPay as a phased fintech prototype.

## Non-Negotiable Rules

1. Work on only the explicitly assigned phase.
2. Inspect existing code and tests before editing.
3. Never bypass the ledger for monetary state changes.
4. Never create or store real PANs, CVVs, private keys, seed phrases or production credentials.
5. Treat all bank, mobile-money, NFC, card, crypto and securities integrations as simulated unless an approved sandbox adapter is explicitly provided.
6. Never claim a simulated balance, quote, payment or order is live.
7. Validate all inputs, enforce ownership and roles, and redact sensitive logs.
8. Add tests with every behaviour change.
9. Run the complete required test gate and report exact commands and results.
10. Stop after producing the phase report. Do not continue to the next phase.

When a test fails, diagnose and fix it within the current phase. Do not hide, skip or weaken tests merely to obtain a green result. If a failure cannot be resolved safely, stop and document the blocker.
