### Initialise application customisation tables

## User table (No translation for users)
puts "Seeding users"
if User.none?
  admin_pass = ENV.fetch("ADMIN_PASS") { raise "ADMIN_PASS environment variable is not set" }

  puts "Creating first users"

  # Default placeholder user — id forced to 0, bypasses validations intentionally
  # FK audit columns left nil: self-referential table cannot reference itself at bootstrap
  User.new(
    id: 0,
    code: "unassigned",
    first_name: "Undefined",
    last_name: "User",
    email: "unassigned@opendataquality.com",
    active_from: "2000-01-01",
    active_to: "2100-01-01",
    password: admin_pass,
    password_confirmation: admin_pass
  ).save(validate: false)

  unassigned = User.find(0)

  # Administrator
  User.new(
    code: "admin",
    first_name: "Open Data Quality",
    last_name: "Administrator",
    email: "admin@opendataquality.com",
    active_from: "2000-01-01",
    active_to: "2100-01-01",
    owner_id: unassigned.id,
    created_by_id: unassigned.id,
    updated_by_id: unassigned.id,
    password: admin_pass,
    password_confirmation: admin_pass
  ).save(validate: false)

  puts User.pluck(:code).inspect
  Rails.logger.info "Created users: #{User.pluck(:code).join(", ")}"
  puts "---"
end
