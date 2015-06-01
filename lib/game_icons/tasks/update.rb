require 'game_icons'
require 'open-uri'
require 'zip'

module GameIcons
  class Update
    @@URL     = 'http://game-icons.net/archives/svg/zip/ffffff/000000/game-icons.net.svg.zip'
    @@TMP_ZIP = 'game-icons.net.svg.zip'

    def self.run
      puts "Downloading..."
      download
      puts "Unzipping won't work because rubyzip is dumb..."
      # unzip
      puts "Done."
    end

    private
    def self.download
      File.open(@@TMP_ZIP, 'w+') do |save_file|
        open(@@URL, 'rb') { |read_file| save_file.write(read_file.read) }
      end
    end

    # def self.unzip
    #   zf = Zip::File.open('game-icons.net.svg.zip') # FAIL!!
    #   # puts zf.get_next_entry
    # end

  end
end