module Fron
  module Adapters
    class RailsAdapter
      def transform(data)
        newdata = {}
        newdata[:authenticity_token] = DOM::Document.head.find("meta[name=csrf-token]")['content']
        newdata[@options[:resource]] = data.dup
        newdata
      end
    end
  end

  class Model
    def update(attributes = {}, &block)
      data = geather.merge! attributes
      self.class.instance_variable_get("@adapterObject").set id, data do |errors|
        @errors = errors
        merge data
        block.call if block_given?
      end
    end

    def geather
      @data.dup.reject{|key| !self.class.fields.include?(key)}
    end

    def merge(data)
      data.each_pair do |key,value|
        if self.respond_to?(key+"=")
          self.send(key+"=", value)
        else
          @data[key] = value
        end
      end
    end
  end

  class Router
    def self.pathToRegexp(path)
      return path if path == "*"
      {regexp: Regexp.new('^'+path.gsub(/:([^\/]+)/, '(.+)')+"$"), map: path.match(/:([^\/]+)/).to_a[1..-1] }
    end

    def applyRoute(controller,route, params = {})
      if controller.class.beforeFilters
        controller.class.beforeFilters.each do |filter|
          if filter[:actions].include?(route[:action])
            controller.send(filter[:method], params)
          end
        end
      end
      controller.send(route[:action], params)
      @config.logger.info "Navigate >> #{controller.class}##{route[:action]} with params #{params}"
      @config.main.empty
      if @config.injectBlock
        @config.injectBlock.call controller.base
      else
        @config.main << controller.base
      end
    end
  end

  class Configuration
    attr_accessor :customInject, :injectBlock
    attr_reader :routeBlock, :main, :app

    def layout(&block)
    end

    def customInject(&block)
      @injectBlock = block
    end
  end
end

