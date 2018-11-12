class Publish

  def self.call(name, message)
    uri = Addressable::URI.parse(CONFIG[:chat_server_url])
    uri.path = "/message"

    Excon.post(uri.to_s, body: URI.encode_www_form(name: name, data: message))
  end

end
