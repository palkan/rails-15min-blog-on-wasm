ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::DiskController.after_action only: :show do
    expires_in 1.year, public: true
  end

  ActivestorageDatabase::FilesController.after_action only: :show do
    expires_in 1.year, public: true
  end

  require "active_storage/service/database_service"
  ActiveStorage::Service::DatabaseService.prepend(Module.new do
    # Override to use SQLite functions and ensure binary type is used
    def download_chunk(key, range)
      instrument :download_chunk, key: key, range: range do
        chunk_select = "SUBSTR(data, #{range.begin + 1}, #{range.size}) AS data"
        ActivestorageDatabase::File.select(chunk_select).find_by(key:)&.data|| raise(ActiveStorage::FileNotFoundError)
      end
    end
  end)
end
