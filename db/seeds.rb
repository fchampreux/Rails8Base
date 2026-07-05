# Usage: ADMIN_PASS=#DQAdmin01! rails db:seed
if ENV["ADMIN_PASS"]
  Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
    puts "Processing #{file.split('/').last}"
    require file
  end
else
  puts "Please provide strong Administrator password: 8 positions including at least 1 upper case letter, 1 lowercase letter, 1 number, 1 sign (other than '_')"
  puts "Usage: ADMIN_PASS=<password> rails db:seed"
end
