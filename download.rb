require 'csv'
require_relative './downloader'

CONTAINER_NAME = 'csv-data'
BLOB_NAME = 'data.csv'

downloader = Downloader.new(CONTAINER_NAME, BLOB_NAME)

puts 'Downloading...'
downloader.open do |file_name|
  row_number = 1

  CSV.foreach(file_name, headers: true) do |row|
    puts "#{row_number} #{row['first_name']} #{row['last_name']}"
    row_number += 1
  end
end
