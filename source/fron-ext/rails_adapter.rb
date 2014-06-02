module Fron
  module Adapters
    class RailsAdapter
      def del(model,&block)
        setUrl model
        @request.request 'DELETE', transform({})  do
          block.call
        end
      end

      def transform(data)
        newdata = {}
        newdata[:authenticity_token] = DOM::Document.head.find("meta[name=csrf-token]")['content']
        newdata[@options[:resource]] = data.dup
        newdata
      end

      def set(model,data,&block)
        setUrl model
        method = model.id ? 'put' : 'post'
        @request.send(method,transform(data)) do |response|
          error = case response.status
          when 201, 204
            nil
          when 422
            response.json
          end
          block.call error, response.json
        end
      end

      def setUrl(model)
        id = model.is_a?(Fron::Model) ? model.id : model
        endpoint = if @options[:endpoint].is_a? Proc
            model.instance_eval &@options[:endpoint]
          else
            @options[:endpoint]
          end
        base = endpoint + "/" + @options[:resources]
        base += id ? "/" + id.to_s : ".json"
        @request.url = base
      end
    end
  end

  class Model
    def update(attributes = {}, &block)
      data = gather.merge! attributes
      self.class.instance_variable_get("@adapterObject").set self, data do |errors,data|
        @errors = errors
        merge data
        block.call if block_given?
      end
    end

    def clone(data = {})
      cl = self.class.new @data.merge data
      cl.instance_variable_set "@errors", self.errors
      cl
    end

    def destroy(&block)
      self.class.instance_variable_get("@adapterObject").del self do
        block.call if block_given?
      end
    end

    def gather
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
      {regexp: Regexp.new('^'+path.gsub(/:([^\/]+)/, '([^\/]+)')), map: path.scan(/:([^\/]+)/).flatten }
    end

    def route(hash = DOM::Window.hash, controller = nil,startParams = {})
      routes = controller ? (controller.class.routes || []) : @routes
      routes.each do |r|
        if r[:path] == '*'
          if r[:controller]
            break route(hash,r[:controller],startParams)
          else
            break applyRoute(controller,r,startParams)
          end
        else
          matches = hash.match(r[:path][:regexp]).to_a[1..-1]
          if matches
            params = {}
            if r[:path][:map]
              r[:path][:map].each_with_index do |key, index|
                params[key.to_sym] = matches[index]
              end
            end
            if r[:action]
              break applyRoute(controller,r,startParams.merge(params))
            else
              break route hash.gsub(r[:path][:regexp],''), r[:controller], startParams.merge(params)
            end
          end
        end
      end
    end

    def applyRoute(controller,route, params = {})
      if controller.class.beforeFilters
        controller.class.beforeFilters.each do |filter|
          if filter[:actions].include?(route[:action])
            controller.send(filter[:method], params)
          end
        end
      end
      controller.send(:empty) if controller.respond_to?(:empty)
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

module DOM
  class Element
    def insertBefore(what,where)
      `#{@el}.insertBefore(#{NODE.getElement what},#{NODE.getElement where})`
    end

    def disabled
      `#{@el}.disabled`
    end

    def disabled=(value)
      `#{@el}.disabled = #{value}`
    end
  end
end
