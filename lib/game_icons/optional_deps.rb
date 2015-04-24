module GameIcons
  class OptionalDeps
    class << self #everything's static here too
      def require_nokogiri
        begin
          require 'nokogiri'
        rescue
          raise "Nokogiri is required for this feature. Please install using 'gem install nokogiri'"
        end
      end
    end
  end
end