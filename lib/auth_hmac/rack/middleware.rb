require 'rack/request'

module AuthHmac
  module Rack
    class Middleware
      # @params Object app: Another Rack app, just a class responding to .call
      # @params Hash options: {:keys=>{'access_key_id1'=>'secret1', ...}, :only=>['a/path', 'backend', 'api'] }
      def initialize(app, opts = {})
        @app = app
        @options = options
      end

      def call(env)
        if check_hmac? env
          @auth_hmac = AuthHMAC.new @options[:secrets]
          
          if authenticated? env
            @app.call(env)
          else
            [401, { 'WWW-Authenticate' => 'AuthHMAC' }, ["HMAC Authentication failed."]]
          end
        else # unprotected
          @app.call(env)
        end
      end
      
      private
      
      def check_hmac?
        path = env['PATH_INFO'] || ''
        @options[:only].detect { |p| path.include? p }
      end
      
      def authenticated?(request)
        @auth_hmac.authenticated? Rack::Request.new(request)
      end
    end
  end
end
