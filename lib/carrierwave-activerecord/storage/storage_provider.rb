# encoding: utf-8

module CarrierWave
  module Storage
    module ActiveRecord 
      class StorageProvider < Abstract
        ##
        # Store a file
        #
        # === Parameters
        #
        # [file (CarrierWave::SanitizedFile)] the file to store
        #
        # === Returns
        #
        # [CarrierWave::Storage::ActiveRecord::File] the stored file
        #
        def store!(file)
          CarrierWave::Storage::ActiveRecord::FileProxy.create!(file, uploader.identifier)
        end

        ##
        # Retrieve a file
        #
        # === Parameters
        #
        # [identifier (String)] unique identifier for file
        #
        # === Returns
        #
        # [CarrierWave::Storage::ActiveRecord::File] the stored file
        #
        def retrieve!(identifier)
          FileProxy.fetch!(identifier)
        end

        def identifier
          "/#{uploader.store_dir}/#{uploader.filename}"
        end
      end 
    end # ActiveRecord
  end # Storage
end # CarrierWave
