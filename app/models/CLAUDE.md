# Model Conventions

## Mandatory columns

Every model must include the following columns:

| Column          | Type        | Constraints              | Index          |
|-----------------|-------------|--------------------------|----------------|
| `code`          | string(64)  | NOT NULL, default: ""    | unique         |
| `uuid`          | uuid        | NOT NULL, default: gen_random_uuid() | unique |
| `owner_id`      | integer     | NOT NULL                 | yes (FK)       |
| `created_by_id` | integer     | NOT NULL                 | yes (FK)       |
| `updated_by_id` | integer     | NOT NULL                 | yes (FK)       |
| `is_active`     | boolean     | NOT NULL, default: false | yes            |
| `description`   | json        |                          | no             |

`owner_id`, `created_by_id` and `updated_by_id` are foreign keys referencing the `users` table.

## Migration template

```ruby
t.string  :code,           limit: 64, null: false, default: ""
t.uuid    :uuid,                       null: false, default: "gen_random_uuid()"
t.integer :owner_id,                   null: false
t.integer :created_by_id,              null: false
t.integer :updated_by_id,              null: false
t.boolean :is_active,                  null: false, default: true
t.json    :description

add_index :table_name, :code,           unique: true
add_index :table_name, :uuid,           unique: true
add_index :table_name, :owner_id
add_index :table_name, :created_by_id
add_index :table_name, :updated_by_id

add_foreign_key :table_name, :users, column: :owner_id
add_foreign_key :table_name, :users, column: :created_by_id
add_foreign_key :table_name, :users, column: :updated_by_id
```

## Model template

```ruby
belongs_to :owner,      class_name: "User", foreign_key: :owner_id
belongs_to :created_by, class_name: "User", foreign_key: :created_by_id
belongs_to :updated_by, class_name: "User", foreign_key: :updated_by_id

validates :code,      presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 64 }
validates :uuid,      presence: true, uniqueness: true
validates :is_active, inclusion: { in: [ true, false ] }

scope :active,   -> { where(is_active: true) }
scope :inactive, -> { where(is_active: false) }
```

## Versioned models

Add `include Versionable` to activate versioning on a model. The following columns are then required in the migration:

| Column          | Type       | Constraints                | Index |
|-----------------|------------|----------------------------|-------|
| `version`       | string(12) | NOT NULL, default: "0.0.0" | no  |
| `is_active`     | boolean    | NOT NULL, default: false   | yes |
| `is_current`    | boolean    | NOT NULL, default: true    | yes |
| `is_finalised`  | boolean    | NOT NULL, default: false   | yes |
| `is_published`  | boolean    | NOT NULL, default: true    | yes |
| `is_template`   | boolean    | NOT NULL, default: true    | yes |

`is_active` is already required by the mandatory columns — listed here for completeness.

```ruby
t.string  :version,      limit: 12, null: false, default: "0.0.0"
t.boolean :is_active,               null: false, default: false
t.boolean :is_current,              null: false, default: true
t.boolean :is_finalised,            null: false, default: false
t.boolean :is_published,            null: false, default: true
t.boolean :is_template,             null: false, default: true

add_index :table_name, :is_active
add_index :table_name, :is_current
add_index :table_name, :is_finalised
add_index :table_name, :is_published
add_index :table_name, :is_template
```

Non-versioned models do **not** include `Versionable` — `versioned?` returns `false` via `ApplicationRecord`.

## Do NOT

- Do not omit any of the mandatory columns above
- Do not use `created_by` / `updated_by` as plain strings — use `_id` integer foreign keys
- Do not skip indexes on FK columns
