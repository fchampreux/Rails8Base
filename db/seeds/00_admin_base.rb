### Initialise application customisation tables

## User table (No translation for users)
puts "Seeding users and groups"
if User.none?
  admin_pass = ENV.fetch("ADMIN_PASS") { raise "ADMIN_PASS environment variable is not set" }

  puts "Creating first users"

  # Default placeholder user — id forced to 0, bypasses validations intentionally
  # FK audit columns set to 0: self-referential bootstrap row references itself
  # confirmed_at set explicitly: :confirmable would block sign-in otherwise
  User.new(
    id: 0,
    code: "unassigned",
    first_name: "Undefined",
    last_name: "User",
    email: "unassigned@opendataquality.com",
    active_from: "2000-01-01",
    active_to: "2100-01-01",
    confirmed_at: Time.current,
    password: admin_pass,
    password_confirmation: admin_pass,
    owner_id: 0,
    created_by_id: 0,
    updated_by_id: 0
  ).save(validate: false)

  unassigned = User.find(0)

  # Administrator
  admin = User.new(
    code: "admin",
    first_name: "Open Data Quality",
    last_name: "Administrator",
    email: "admin@opendataquality.com",
    active_from: "2000-01-01",
    active_to: "2100-01-01",
    confirmed_at: Time.current,
    owner_id: unassigned.id,
    created_by_id: unassigned.id,
    updated_by_id: unassigned.id,
    is_admin: true,
    password: admin_pass,
    password_confirmation: admin_pass
  )
  admin.save(validate: false)

  puts User.pluck(:code).inspect
  Rails.logger.info "Created users: #{User.pluck(:code).join(", ")}"
  puts "---"
end

if Group.none?
  puts "Creating first group"
  admin = User.find_by(code: "admin")
  group = Group.new(
    code: "Everyone",
    owner_id: admin.id,
    created_by_id: admin.id,
    updated_by_id: admin.id,
    sort_code: "a"
  )
  group.save(validate: false)
end

if UsersGroup.none?
  puts "Inserting users in default group"
  group = Group.find_by(code: "Everyone")
  User.find_each do |user|
    UsersGroup.create!(
      user_id: user.id,
      group_id: group.id,
      is_active: true,
      active_from: Time.current,
      active_to: "2100-01-01"
    )
  end
end
