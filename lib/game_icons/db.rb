module GameIcons
  class DB
    # Class-level hash of icon names to their absolute path in this gem
    @@icons = Hash.new

    class << self # everything here is basically static
      def init
        return unless @@icons.empty?
        resources = File.expand_path('../../resources', File.dirname(__FILE__))
        Dir.glob("#{resources}/**/*.svg").each do |svg|
          name          = File.basename(svg,'.svg').downcase #chop off .svg
          @@icons[name] = svg
        end
      end

      def names
        init
        @@icons.keys
      end

      def files
        init
        @@icons
      end
    end
  end
end
