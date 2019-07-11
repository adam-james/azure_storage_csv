require 'faker'

TOTAL = 1_000_000

File.open('data.csv', 'wb') do |f|
  f.write "first_name,last_name\n"

  TOTAL.times do |index|
    puts "#{index} of #{TOTAL}"
    f.write "#{Faker::Name.first_name},#{Faker::Name.last_name}\n"
  end
end
