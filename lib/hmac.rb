module HMAC
  HMAC_KEY = ENV['HMAC_KEY'] || "13766d759964a729c613d40ca2189ac8f8ec1a88c03ecbfc1e46c295971412be42dfbb98a1265c8638a8173b"

  def self.id(*strings)
    digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.hexdigest(digest, HMAC_KEY, strings.join(""))
    hmac[0...6]
  end
end
