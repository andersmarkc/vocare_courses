# Models rules (app/models/)

Applies when working on any file in this directory.

## Enums

Use Rails string enums with explicit values. Never integer enums.

```ruby
# CORRECT
enum :content_type, { video: "video", audio: "audio", text: "text" }

# WRONG
enum :content_type, { video: 0, audio: 1, text: 2 }
```

## Validations

- Always validate at both the DB level (migration index/constraint) and model level
- Use `uniqueness` with scope where appropriate (e.g., lesson position scoped to section)

## Progression Logic

Section unlock is determined by `Progress::Tracker`, not by model callbacks. Models only store state; the service calculates what's unlocked.

## Naming

- Students are "customers" everywhere: `Customer` model, `customer_id` foreign keys
- Use `quizzable` for the polymorphic Quiz association (Section or Course)
