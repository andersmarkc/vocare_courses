# /ci

Run the full CI pipeline and fix all failures before proceeding.

## Steps

1. `bin/rubocop -a` — auto-fix style violations
2. `bin/rubocop` — must be zero offenses
3. `bin/brakeman --quiet --no-pager` — must pass. Fix any security warnings.
4. `bin/bundler-audit check --update` — must pass
5. `bundle exec rspec` — must be zero failures
6. Fix everything that fails. Do not proceed until all checks pass.
7. Report: what passed, what needed fixing.

All checks must pass before any commit. No exceptions.
