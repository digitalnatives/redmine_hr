module HR
  def self.server
    server = Opal::Server.new do |server|
      server.index_path = File.expand_path(File.dirname(__FILE__) + '/../index.html')
      server.append_path File.expand_path(File.dirname(__FILE__) + '/../source')
      server.debug = false
    end
  end
end
