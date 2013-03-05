# Integration with Rails
#
class Rails # :nodoc:
  module ControllerFilter # :nodoc:
    module ClassMethods
      # Call within a Rails Controller to initialize HMAC authentication for the controller.
      #
      # * +credentials+ must be a hash that indexes secrets by their access key id.
      # * +options+ supports the following arguments:
      #   * +failure_message+: The text to use when authentication fails.
      #   * +only+: A list off actions to protect.
      #   * +except+: A list of actions to not protect.
      #   * +hmac+: Options for HMAC creation. See AuthHMAC#initialize for options.
      #
      def with_auth_hmac(credentials, options = {})
        unless credentials.nil?
          self.credentials = credentials
          self.authhmac_failure_message = (options.delete(:failure_message) or "HMAC Authentication failed")
          self.authhmac = AuthHMAC.new(self.credentials, options.delete(:hmac))
          before_filter(:hmac_login_required, options)
        else
          $stderr.puts("with_auth_hmac called with nil credentials - authentication will be skipped")
        end
      end
    end
    
    module InstanceMethods # :nodoc:
      def hmac_login_required
        unless hmac_authenticated?
          response.headers['WWW-Authenticate'] = 'AuthHMAC'
          render :text => self.class.authhmac_failure_message, :status => :unauthorized
        end
      end
      
      def hmac_authenticated?
        self.class.authhmac.nil? ? true : self.class.authhmac.authenticated?(request)
      end
    end
    
    begin
      require 'action_pack'
      require 'active_support'
      require 'action_controller'
    rescue LoadError => e
      $stderr.puts e.message
    end unless defined? ActionController
    
    if defined? ActionController::Base
      ActionController::Base.class_eval do
        class_attribute :authhmac
        class_attribute :credentials
        class_attribute :authhmac_failure_message
      end
      
      ActionController::Base.send :include, ControllerFilter::InstanceMethods
      ActionController::Base.extend ControllerFilter::ClassMethods
    end
  end
end