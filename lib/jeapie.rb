require 'net/https'
require 'jeapie/version'
require 'active_support/core_ext/object/blank'
require 'active_support/json'

# The primary namespace.
module Jeapie
  class DeliverException < StandardError ; end
  extend self
  # app_token and user_key, you can get it from dashboard.jeapie.com
  attr_accessor :token
  attr_accessor :message, :title, :device, :priority, :emails
  # After call notify it contain result as {Net::HTTPCreated} object, for check result better see {#errors}
  attr_reader :result

  NOTIFY_API_URL= 'https://api.jeapie.com/v2/personal/send/message.json'
  NOTIFY_ALL_API_URL= 'https://api.jeapie.com/v2/broadcast/send/message.json'
  NOTIFY_MULTIPLE_API_URL= 'https://api.jeapie.com/v2/users/send/message.json'
  PRIORITY_LOW=-1
  PRIORITY_MED=0
  PRIORITY_HIGH=1
  MESSAGE_MAX_LEN= 2000

  def configure
    yield self
    parameters
  end

  # available parameters and its values
  def parameters
    h = {}
    keys.each { |k| h[k.to_sym] = Jeapie.instance_variable_get("@#{k}") }
    h
  end
  alias_method :params, :parameters

  # for backward compatibility
  def user=(val)
    puts 'DEPRECATED: parameter "Jeapie.user" is obsolete. You can delete it from your config.'
  end

  # List of available fields, useful for unit test.
  # @return Hash
  def keys
    @keys||= [:token, :message, :title, :device, :priority]
  end

  # Clear stored params, useful for unit tests.
  def clear
    keys.each do |k|
      Jeapie.instance_variable_set("@#{k}", nil)
    end
  end

  # After call {#notify} it contain "false" if all OK, or [string] with error in other case.
  def errors
    return "Params not valid: #{@params_errors}" unless @params_errors && @params_errors.empty?
    return false if result.nil?
    begin
    arr= JSON::parse(result.body)
    rescue JSON::ParserError
      return "Can't parse response: #{result.body}"
    end

    return false if arr['success']
    "code: #{result.code}, errors: #{arr['errors']}"
  end

  # Send message to one user through Jeapie.
  # example:
  #  notify message:'Backup complete'
  # or:
  #  notify title:'Backup complete', message:'Time elapsed 50s, size: 500Mb', priority:-1, device:'Nexus7', token:''
  #
  # If this method return +false+, you can check {#errors} for text, or you can use {#notify!} for raise +DeliverException+ if any problem
  # @return [true, false]
  def notify(opts={message:''})
    send_notify(NOTIFY_API_URL, opts)
  end

  # Send message to all subscribers of application.
  # example:
  #  notify_all message:'Backup complete'
  # or:
  #  notify_all title:'Backup complete', message:'Time elapsed 50s, size: 500Mb', priority:-1, device:'Nexus7', token:''
  #
  # If this method return +false+, you can check {#errors} for text, or you can use {#notify_all!} for raise +DeliverException+ if any problem
  # @return [true, false]
  def notify_all(opts={message:''})
    send_notify(NOTIFY_ALL_API_URL, opts)
  end

  # Send message to some subscribers of application.
  # example:
  #  notify_all message:'Backup complete', emails:['user1@mail.com', 'user3@mail.com']
  #  notify_all message:'Backup complete', emails:'user1@mail.com, user3@mail.com'
  #
  # If this method return +false+, you can check {#errors} for text, or you can use {#notify_multiple!} for raise +DeliverException+ if any problem
  # @return [true, false]
  def notify_multiple(opts={message:'', emails:[]})
    send_notify(NOTIFY_MULTIPLE_API_URL, opts)
  end

  # Similar to {#notify}, but raise +DeliverException+ if any problem
  # @return [true]
  def notify!(opts={message:''})
    raise DeliverException, errors unless notify(opts)
    true
  end

  # Similar to {#notify_all}, but raise +DeliverException+ if any problem
  # @return [true]
  def notify_all!(opts={message:''})
    raise DeliverException, errors unless notify_all(opts)
    true
  end

  # Similar to {#notify_multiple}, but raise +DeliverException+ if any problem
  # @return [true]
  def notify_multiple!(opts={message:'', emails:[]})
    raise DeliverException, errors unless notify_multiple(opts)
    true
  end

  protected
  def params_errors(params, api_url)
    @params_errors=[]
    @params_errors<<'Token cannot be blank' if params[:token].blank?
    @params_errors<<'Token must be 32 symbols' if params[:token].size != 32
    @params_errors<<'Message cannot be blank' if params[:message].blank?
    @params_errors<<'Emails cannot be blank' if params[:emails].blank? && api_url==NOTIFY_MULTIPLE_API_URL
    @params_errors<<"Message too long, max: #{MESSAGE_MAX_LEN}" if params[:message] && params[:message].size > MESSAGE_MAX_LEN
    @params_errors
  end

  def send_notify(api_url, options={})
    data = params.merge(options).select { |_, v| v != nil }
    data[:emails]=data[:emails].join(',') if !data[:emails].blank? && data[:emails].is_a?(Array)
    return false unless params_errors(data, api_url).empty?
    url = URI.parse(api_url)
    req = Net::HTTP::Post.new(url.path, {'User-Agent' => "Ruby jeapie gem: #{Jeapie::VERSION}"})
    req.set_form_data(data)

    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @result= res.start {|http| http.request(req) }
    errors ? false : true
  end


end
