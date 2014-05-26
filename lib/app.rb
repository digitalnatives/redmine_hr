class YamlProcessor < Sprockets::Processor
	self.default_mime_type = 'application/javascript'
  def evaluate(context, locals)
  	ret = "I18n.translations || (I18n.translations = {});"
    YAML::load(data).each do |key,value|
    	ret += "I18n.translations['#{key}'] = #{value.to_json};"
    end
    ret
  end
end

Sprockets.register_engine '.yml', YamlProcessor

module HR
  def self.server
    server = Opal::Server.new do |server|
      server.index_path = File.expand_path(File.dirname(__FILE__) + '/../index.html')
      server.append_path File.expand_path(File.dirname(__FILE__) + '/../source')
      server.append_path File.expand_path(File.dirname(__FILE__) + '/../config')
      server.debug = false
    end
  end
end
