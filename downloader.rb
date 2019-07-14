require 'dotenv/load'
require 'azure/storage/blob'

# TODO rename to TmpBlobDownloader or something like that
class Downloader
  attr_reader :container_name, :blob_name

  def self.open(container_name, blob_name, &block)
    new(container_name, blob_name).open(&block)
  end

  def initialize(container_name, blob_name)
    @container_name = container_name
    @blob_name = blob_name
  end

  def open
    blob, content = client.get_blob(container_name, blob_name)
    File.open(tmp_file_name, 'wb') { |file| file.write(content) }
    yield tmp_file_name
    File.delete(tmp_file_name)
  end

  private

  def extname
    @extname ||= File.extname(blob_name)
  end

  def basename
    @basename ||= File.basename(blob_name, extname)
  end

  def timestamp
    @timestamp ||= Time.now.to_i
  end

  def tmp_file_name
    @tmp_file_name ||= "#{basename}_#{timestamp}#{extname}"
  end

  def client
    @client ||= Azure::Storage::Blob::BlobService.create(
      storage_account_name: ENV['ACCOUNT_NAME'],
      storage_access_key: ENV['ACCOUNT_KEY']
    )
  end
end
