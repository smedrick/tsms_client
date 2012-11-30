Tsms Client 
===========
This is a ruby client to interact with the GovDelivery TSMS REST API.


# Connecting

``` ruby
client = TSMS::Client.new('username', 'password')

```

# Getting messages

``` ruby
client.subresources
 => {"messages"=><TSMS::Messages href=/messages collection=[]>}
client.messages
 => <TSMS::Messages href=/messages collection=[]>
client.messages.get
 => #lots of stuff
client.messages.next
  => <TSMS::Messages href=/messages/page/2 collection=[]> #if there is a second page
client.messages.next.get
  => # more messages...
```


# Sending a message

``` ruby
message = client.messages.build(:short_body=>'Test Message!')
message.recipients.build(:phone=>'5551112222')
message.recipients.build(:phone=>'5551112223')
message.recipients.build #no phone???
1.9.3-p194-i386 :014 > message.post
 => true
1.9.3-p194-i386 :009 > message.recipients.collection.detect{|r| r.errors }
 => <TSMS::Recipient href= attributes={:provided_phone=>"", :provided_country_code=>nil, :phone=>nil, :country_code=>"1", :status=>nil, :created_at=>nil, :sent_at=>nil, :completed_at=>nil, :errors=>{"phone"=>["is not a number"]}}>
 # save succeeded, but we have one bad recipient
1.9.3-p194-i386 :016 > message.href
  => "/messages/87"
1.9.3-p194-i386 :017 > message.get
=> <TSMS::Message href=/messages/87 attributes={...}>

```

# Logging
Any instance of a [Logger](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html "Ruby Logger")-like class can be passed in to the client; incoming and outgoing
request information will then be logged to that instance. 

The example below configures `TSMS::Client` to log to the terminal attached to `/dev/ttys000`. 

``` ruby
logger = Logger.new(File.open("/dev/ttys000", 'w'))
client = TSMS::Client.new('username', 'password', 'https://endpoint.com', logger)

```

