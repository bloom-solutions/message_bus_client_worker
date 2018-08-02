class Publish

  def self.call(name, message)
    uri = Addressable::URI.parse(CONFIG[:chat_server_url])
    uri.path = "/message"

    HTTP.post(uri.to_s, form: {name: name, data: message})
  end

end
