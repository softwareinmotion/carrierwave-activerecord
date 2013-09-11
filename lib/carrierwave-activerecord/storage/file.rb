# encoding: utf-8

module CarrierWave
  module Storage
    module ActiveRecord
      class File < ::ActiveRecord::Base

        # TODO: Duck-type CarrierWave::SanitizedFile, therefore need methods:
        #
        #   basename
        #   path              # => directory storage .. ?
        #   empty?            # => w.r.t size
        #   exists?           # => get this from AR#exists?  should be a class method.
        #   move_to / copy_to # => we won't need these, how to disable this for our engine?
        #   to_file           # => return a File object
        #   sanitize_regexp   # => CarrierWave::SanitizedFile.sanitize_regexp

        # TODO: Change this at runtime using a configuration setting.
        self.table_name = 'carrier_wave_files'

        # Remove the file from service.
        alias_method :delete, :destroy

        # Read content of file from service.
        alias_attribute :read, :data

        # A url to the file, if available.  Set before the file is returned to CarrierWave.
        attr_accessor :url

        # Check if the file exists on the remote service.
        # TODO: Should be class method somewhere?
        def exists?
          #  self.class.exists?(:filename => filename)
          'CarrierWave::Storage::ActiveRecord::File#exists? FIXME!'
        end

      end # File
    end # ActiveRecord
  end # Storage
end # CarrierWave
