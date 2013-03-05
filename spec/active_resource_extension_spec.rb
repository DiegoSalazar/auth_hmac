# require 'spec_helper'
# require 'active_resource'
# require 'active_resource/http_mock'
# 
# describe AuthHMAC::Rails::ActiveResourceExtension do
#   class TestResource < ActiveResource::Base
#     with_auth_hmac("access_id", "secret")
#     self.site = "http://localhost/"
#   end
# 
#   class CustomTestResource < ActiveResource::Base
#     with_auth_hmac("access_id", "secret", { :service_id => 'MyService', :signature => ::CustomSignature })
#     self.site = "http://localhost/"
#   end
#   
#   describe TestResource do
#     it "should send requests using HMAC authentication" do
#       now = Time.parse("Thu, 10 Jul 2008 03:29:56 GMT")
#       Time.should_receive(:now).at_least(1).and_return(now)
#       ActiveResource::HttpMock.respond_to do |mock|
#         mock.get "/test_resources/1.xml", 
#           {
#             'Authorization' => 'AuthHMAC access_id:44dvKATf4xanDtypqEA0EFYvOgI=',
#             'Accept' => 'application/xml',
#             'Date' => "Thu, 10 Jul 2008 03:29:56 GMT"
#           },
#           { :id => "1" }.to_xml(:root => 'test_resource')
#       end
#       TestResource.find(1)
#     end
#   end
# 
#   describe CustomTestResource do
#     it "should send requests using HMAC authentication" do
#       now = Time.parse("Thu, 10 Jul 2008 03:29:56 GMT")
#       Time.should_receive(:now).at_least(1).and_return(now)
#       ActiveResource::HttpMock.respond_to do |mock|
#         mock.get "/custom_test_resources/1.xml", 
#           {
#             'Authorization' => 'MyService access_id:ZwCBL2rWLOMnwRrdF7wWEdJn7yA=',
#             'Accept' => 'application/xml',
#             'Date' => "Thu, 10 Jul 2008 03:29:56 GMT"
#           },
#           { :id => "1" }.to_xml(:root => 'custom_test_resource')
#       end
#       CustomTestResource.find(1)
#     end
#   end
# end
