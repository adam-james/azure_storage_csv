require 'dotenv/load'
require 'securerandom'
require 'azure/storage/blob'

begin
  blob_client = Azure::Storage::Blob::BlobService.create(
    storage_account_name: ENV['ACCOUNT_NAME'],
    storage_access_key: ENV['ACCOUNT_KEY']
  )
  
  container_name = 'quickstartblobs' + SecureRandom.uuid
  container = blob_client.create_container(container_name)
  
  blob_client.set_container_acl(container_name, 'container')
  
  local_path = File.expand_path('.')
  local_file_name = 'QuickStart_' + SecureRandom.uuid + '.txt'
  full_path_to_file = File.join(local_path, local_file_name)

  puts "Creating tmp file at #{full_path_to_file}"
  file = File.open(full_path_to_file, 'w')
  file.write("Hello, world!\n")
  file.close

  puts "Uploading to blob storage as blob #{local_file_name}"
  file2 = File.open(full_path_to_file, 'r')
  blob_client.create_block_blob(container.name, local_file_name, file2)
  file2.close
  
  full_path_to_file2 = File.join(local_path, local_file_name.gsub('.txt', '_DOWNLOADED.txt'))

  puts "Downloading blob to #{full_path_to_file2}."
  blob, content = blob_client.get_blob(container_name, local_file_name)
  File.open(full_path_to_file2, 'wb') { |f| f.write(content) }
rescue => exception
  puts exception.message
ensure
  puts 'Clean up here.'
end
