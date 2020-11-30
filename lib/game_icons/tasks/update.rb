require 'game_icons'
require 'open-uri'
require 'zip'
require 'fileutils'

module GameIcons
  class Update
    @@URL     = 'http://game-icons.net/archives/svg/zip/ffffff/000000/game-icons.net.svg.zip'
    @@TMP_ZIP = 'game-icons.net.svg.zip'

    def self.run
      puts "Clearing..."
      clear
      puts "Downloading..."
      download
      puts "Unzipping..."
      unzip
      puts "Done."
    end

    private

    def self.clear
      FileUtils.rm_rf('resources/icons')
      FileUtils.mkdir('resources/icons')
    end

    def self.download
      File.open("resources/#{@@TMP_ZIP}", 'wb+') do |save_file|
        open(@@URL, 'rb') { |read_file| save_file.write(read_file.read) }
      end
    end

    def self.unzip
      Zip.on_exists_proc = true #overwrite files if they already exist
      Dir.chdir('./resources/') do
        zip_file = Zip::File.new(@@TMP_ZIP)
        zip_file.each do |entry|
          fpath = "./#{entry.name}"
          FileUtils.mkdir_p File.dirname entry.name
          zip_file.extract(entry, fpath) unless File.exist?(fpath)
          print '.'
        end
      end
    end

  end
end