require 'net/https'
require 'jeapie_push_message/version'

module JeapiePushMessage
  class DeliverException < StandardError ; end
  extend self
  # app_token and user_key, you can get it from dashboard.jeapie.com
  attr_accessor :token, :user
  attr_accessor :message, :title, :device, :priority
  attr_reader :result

  API_URL= 'https://api.jeapie.com/v1/send/message.json'
  PRIORITY_LOW=-1
  PRIORITY_MED=0
  PRIORITY_HIGH=1

  def configure
    yield self
    parameters
  end

  # available parameters and his values
  def parameters
    h = {}
    keys.each { |k| h[k.to_sym] = JeapiePushMessage.instance_variable_get("@#{k}") }
    h
  end
  alias_method :params, :parameters

  def keys
    @keys||= [:token, :user, :message, :title, :device, :priority]
  end

  def errors
    return false if result.nil?
    begin
    arr=JSON::parse(result.body)
    rescue JSON::ParserError
      return "Can't parse response: #{result.body}"
    end

    return false if arr['success']
    "code: #{result.code}, errors: #{arr['errors']}"
  end

  # push a message to Jeapie
  # example: notify message:'Backup complete'
  # or: notify title:'Backup complete', message:'Time elapsed 50s, size: 500Mb', priority:-1, device:'Nexus7', user:'', token:''
  # @return [String] the response from jeapie.com, in json.
  def notify(opts={message:''})
    data = params.merge(opts).select { |_, v| v != nil }
    url = URI.parse(API_URL)
    req = Net::HTTP::Post.new(url.path, {'User-Agent' => "Ruby jeapie gem: #{JeapiePushMessage::VERSION}"})
    req.set_form_data(data)

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @result= res.start {|http| http.request(req) }
    errors ? false : true
  end

  def notify!(opts={message:''})
    raise DeliverException, errors unless notify(opts)
  end
end
