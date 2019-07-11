require 'dotenv/load'
require 'azure/storage/blob'

CONTAINER_NAME = 'data2'
BLOB_NAME = 'csv-data'

client = Azure::Storage::Blob::BlobService.create(
  storage_account_name: ENV['ACCOUNT_NAME'],
  storage_access_key: ENV['ACCOUNT_KEY']
)

container = client.create_container(CONTAINER_NAME)
client.set_container_acl(CONTAINER_NAME, 'container')

File.open('data.csv', 'r') do |file|
  client.create_block_blob(container.name, BLOB_NAME, file)
end
