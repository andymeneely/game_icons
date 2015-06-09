require 'game_icons'
require 'open-uri'

module GameIcons
  class Update
    @@URL     = 'http://game-icons.net/archives/svg/zip/ffffff/000000/game-icons.net.svg.zip'
    @@TMP_ZIP = 'game-icons.net.svg.zip'

    def self.run
      puts "Downloading..."
      download
      puts "Unzipping..."
      unzip
      puts "Done."
    end

    private
    def self.download
      File.open("resources/#{@@TMP_ZIP}", 'wb+') do |save_file|
        open(@@URL, 'rb') { |read_file| save_file.write(read_file.read) }
      end
    end

    def self.unzip
      Dir.chdir('./resources/') do
        `unzip -o game-icons.net.svg.zip`
      end
    end

  end
end