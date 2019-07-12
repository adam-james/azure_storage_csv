require 'dotenv/load'
require 'azure/storage/blob'
require 'csv'

CONTAINER_NAME = 'csv-data'
BLOB_NAME = 'data.csv'
TMP_FILE_NAME = 'tmp-csv-data.csv'

client = Azure::Storage::Blob::BlobService.create(
  storage_account_name: ENV['ACCOUNT_NAME'],
  storage_access_key: ENV['ACCOUNT_KEY']
)

puts 'Downloading csv...'
blob, content = client.get_blob(CONTAINER_NAME, BLOB_NAME)
File.open(TMP_FILE_NAME, 'wb') do |file|
  file.write content
end

row_number = 1

CSV.foreach(TMP_FILE_NAME, headers: true) do |row|
  puts "#{row_number} #{row['first_name']} #{row['last_name']}"
  row_number += 1
end

puts 'Deleting tmp file...'
File.delete TMP_FILE_NAME

puts 'Done.'
