# Class for doing a custom signature
class CustomSignature < String
  def initialize(request)
    self << "Custom signature string: #{request.method}"
  end
end

def signature(value, secret)
  digest = OpenSSL::Digest::Digest.new('sha1')
  Base64.encode64(OpenSSL::HMAC.digest(digest, secret, value)).strip
end
