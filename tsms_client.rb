require 'rubygems'
require 'sinatra'
require 'tsms_client'

get '/voice' do
  erb :voice
end

get '/sms' do
  erb :sms
end

post '/sms' do
	client = TSMS::Client.new(params[:username], params[:password], params[:server].empty? ? nil : params[:server])
	if client.respond_to?('messages')
		message = client.messages.build(:short_body=>params[:short_body])
		phone_numbers = params[:phone_number].split(",")
		phone_numbers.each do |phone_number|
			message.recipients.build(:phone=>phone_number)
		end
		@resp = message.post
		@errors = message.recipients.collection.detect{|r| r.errors }
		@msg = message.get
		
		erb :sms
	else
		"Invalid credentials"
	end 
end

post '/voice' do
  client = TSMS::Client.new(params[:username], params[:password], params[:server].empty? ? nil : params[:server])
  if client.respond_to?('messages')
    message = client.messages.build(:url=>params[:url])
    phone_numbers = params[:phone_number].split(",")
    phone_numbers.each do |phone_number|
      message.recipients.build(:phone=>phone_number)
    end
    @resp = message.post
    @errors = message.recipients.collection.detect{|r| r.errors }
    @msg = message.get

    erb :voice
  else
    "Invalid credentials"
  end
end

get '/messages' do
	erb :messages
end

post '/messages' do
	client = TSMS::Client.new(params[:username], params[:password], params[:server].empty? ? nil : params[:server])
	if client.respond_to?('messages')
		@msgs = client.messages.get
		@baseurl = params[:server]
	else
		"Invalid credentials"
	end		
	erb :messages
end

get '/message/:mid' do
	client = TSMS::Client.new('product@evotest.govdelivery.com', 'retek01!', 'https://stage-tsms.govdelivery.com')
	if client.respond_to?('messages')
		msgs = client.messages.get
		@msg = msgs.collection.first
	else
		"Invalid credentials"
	end		
	
	@msg.recipients.inspect
end
