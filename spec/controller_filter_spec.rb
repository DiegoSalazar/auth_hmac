# require 'spec_helper'
# require 'action_controller'
# require 'action_controller/test_case'
# 
# describe AuthHMAC::Rails::ControllerFilter do
#   class TestController < ActionController::Base
#     with_auth_hmac YAML.load(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'credentials.yml'))),
#       :only => [:index]
#     
#     def index
#       render :nothing => true, :status => :ok
#     end
#     
#     def public
#       render :nothing => true, :status => :ok
#     end
#     
#     def rescue_action(e) raise(e) end
#   end
#   
#   class MessageTestController < ActionController::Base
#     with_auth_hmac YAML.load(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'credentials.yml'))),
#                     :failure_message => "Stay away!", :except => :public
#     
#     def index
#       render :nothing => true, :status => :ok
#     end
#     
#     def public
#       render :nothing => true, :status => :ok
#     end
#     
#     def rescue_action(e) raise(e) end
#   end
#   
#   class NilCredentialsController < ActionController::Base
#     with_auth_hmac nil
#     before_filter :force_auth
#     
#     def index
#       render :nothing => true, :status => :ok
#     end
#     
#     def public
#       render :nothing => true, :status => :ok
#     end
#     
#     def rescue_action(e) raise(e) end
#       
#     private
#     def force_auth
#       hmac_authenticated?
#     end
#   end
# 
#   class CustomTestController < ActionController::Base
#     with_auth_hmac YAML.load(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'credentials.yml'))),
#       :failure_message => "Stay away!",
#       :except => :public,
#       :hmac => { :service_id => 'MyService', :signature => CustomSignature }
#     
#     def index
#       render :nothing => true, :status => :ok
#     end
#     
#     def public
#       render :nothing => true, :status => :ok
#     end
#     
#     def rescue_action(e) raise(e) end
#   end
#   
#   describe NilCredentialsController do
#     it "should not raise an error when credentials are nil" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.path = "/index"
#       lambda do
#         NilCredentialsController.new.process(request, ActionController::TestResponse.new).code.should == "200"
#       end.should_not raise_error
#     end
#   end
#  
#   describe TestController do
#     it "should allow a request with the proper hmac" do
#       request = ActionController::TestRequest.new
#       request.env['Authorization'] = "AuthHMAC access key 1:6BVEVfAyIDoI3K+WallRMnDxROQ="
#       request.env['DATE'] = "Thu, 10 Jul 2008 03:29:56 GMT"
#       request.action = 'index'
#       request.path = "/index"
#       TestController.new.process(request, ActionController::TestResponse.new).code.should == "200"
#     end
# 
#     it "should reject a request with no hmac" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       TestController.new.process(request, ActionController::TestResponse.new).code.should == "401"
#     end
# 
#     it "should reject a request with the wrong hmac" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.env['Authorization'] = "AuthHMAC bogus:bogus"
#       TestController.new.process(request, ActionController::TestResponse.new).code.should == "401"
#     end
# 
#     it "should include a WWW-Authenticate header with the schema AuthHMAC" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.env['Authorization'] = "AuthHMAC bogus:bogus"
#       TestController.new.process(request, ActionController::TestResponse.new).headers['WWW-Authenticate'].should == "AuthHMAC"
#     end
# 
#     it "should include a default error message" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.env['Authorization'] = "AuthHMAC bogus:bogus"
#       TestController.new.process(request, ActionController::TestResponse.new).body.should == "HMAC Authentication failed"
#     end
# 
#     it "should allow anything to access the public action (using only)" do
#       request = ActionController::TestRequest.new
#       request.action = 'public'
#       TestController.new.process(request, ActionController::TestResponse.new).code.should == "200"
#     end
#   end
# 
#   describe MessageTestController do
#     it "should reject a request with a given message" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.env['Authorization'] = "AuthHMAC bogus:bogus"
#       MessageTestController.new.process(request, ActionController::TestResponse.new).body.should == "Stay away!"
#     end
# 
#     it "should allow anything to access the public action (using except)" do
#       request = ActionController::TestRequest.new
#       request.action = 'public'
#       MessageTestController.new.process(request, ActionController::TestResponse.new).code.should == "200"
#     end
#   end
# 
#   describe CustomTestController do
#     it "should allow a request with the proper hmac" do
#       request = ActionController::TestRequest.new
#       request.env['Authorization'] = "MyService access key 1:J2W4dOrv/sGsL0C5adnZYiQ3d70="
#       request.env['DATE'] = "Thu, 10 Jul 2008 03:29:56 GMT"
#       request.action = 'index'
#       request.path = "/index"
#      CustomTestController.new.process(request, ActionController::TestResponse.new).code.should == "200"
#     end
# 
#     it "should reject a request with no hmac" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       CustomTestController.new.process(request, ActionController::TestResponse.new).code.should == "401"
#     end
# 
#     it "should reject a request with the wrong hmac" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.env['Authorization'] = "AuthHMAC bogus:bogus"
#       CustomTestController.new.process(request, ActionController::TestResponse.new).code.should == "401"
#     end
# 
#     it "should reject a request with a given message" do
#       request = ActionController::TestRequest.new
#       request.action = 'index'
#       request.env['Authorization'] = "AuthHMAC bogus:bogus"
#       CustomTestController.new.process(request, ActionController::TestResponse.new).body.should == "Stay away!"
#     end
# 
#     it "should allow anything to access the public action (using except)" do
#       request = ActionController::TestRequest.new
#       request.action = 'public'
#       CustomTestController.new.process(request, ActionController::TestResponse.new).code.should == "200"
#     end
#   end
# end
