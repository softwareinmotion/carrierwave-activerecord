require 'spec_helper'

module CarrierWave 
  module Storage
    module ActiveRecord 
      describe FileProxy do
        let(:file_record) { File.create!(@initialization_values.merge({:storage_path => "/uploads/sample.png"})) }
        before :each do
          CarrierWave::Storage::ActiveRecord::File.delete_all
          @file = double('file')
          @initialization_values = { filename: 'sample.png', original_filename: 'o_sample.png', content_type: 'image/png', size: 123, extension: 'png', data: 1337 }
          @initialization_values.each do |property, value|
            @file.stub(property => value)
          end
          @file.stub(:read => 1337)
        end

        describe '.create!(file)' do
          before :each do
            @ar_file = double('active record file')
            @ar_file.stub(:save)
          end

          it 'creates a new instance of the File class' do
            File.should_receive(:new).and_return(@ar_file)
            FileProxy.create!(@file,"/uploads/sample.png")
          end

          it 'returns an instance of FileProxy associated with created File' do
            File.stub(:new => @ar_file)

            FileProxy.create!(@file,"/uploads/sample.png").file.should eq(@ar_file)
          end

          it 'creates a file record in the database' do
            expect { FileProxy.create!(@file,"/uploads/sample.png") }.to change(File, :count).by(1)
          end

          it 'initializes the file instance' do
            proxy = FileProxy.create!(@file,"/uploads/sample.png")
            
            @initialization_values.each do |property, value|
              proxy.file.send(property).should eq(value)
            end
          end

          it 'sets the storage path on the file' do
            file = FileProxy.create!(@file, "/uploads/sample.png").file

            file.storage_path.should eq("/uploads/sample.png")
          end
        end

        describe '.fetch!(identifier)' do
          context 'given the file exists' do
            before :each do
              file_record # ensure its present
            end

            it 'returns the file wrapped in a CarrierWave::Storage::ActiveRecord::FileProxy object' do
              FileProxy.fetch!("/uploads/sample.png").should be_instance_of ::CarrierWave::Storage::ActiveRecord::FileProxy
            end

            it 'sets the proxy file property to the file record object' do
              FileProxy.fetch!("/uploads/sample.png").file.should eq(file_record)
            end
          end

          context "given the file doesn't exist" do
            it 'returns an blank instance of CarrierWave::Storage::ActiveRecord::FileProxy' do
              FileProxy.fetch!("/uploads/sample.png").should be_instance_of ::CarrierWave::Storage::ActiveRecord::FileProxy
            end
          end
        end

        describe "#url" do
          let(:file_proxy) { FileProxy.fetch! "/uploads/sample.png" }

          context 'given the file exists' do
            it 'returns Uploader.downloader_path_prefix + file.storage_path' do
              file_record #ensure its present
              file_proxy.url.should eq("/files/uploads/sample.png")
            end
          end

          context 'given the file proxy is blank' do
            it 'returns nil' do
              file_proxy.url.should be_nil
            end
          end
        end

        describe "#blank?" do
          it 'must be tested'
        end

        describe '#delete' do
          context 'given the proxy is associated with a file' do
            before :each do
              file_record # ensure it's present
              @proxy = FileProxy.fetch!("/uploads/sample.png")
            end

            it 'deletes the record' do
              expect { @proxy.delete }.to change( File, :count).by(-1)
            end

            it 'returns true' do
              @proxy.delete.should be_true
            end

          end

          context "given the proxy isn't associated with a file" do
            it 'does nothing' do
              proxy = FileProxy.fetch!("non-existing-identifier")
              proxy.delete.should be_false
            end
          end
        end
      end
    end
  end # Storage
end # CarrierWave
