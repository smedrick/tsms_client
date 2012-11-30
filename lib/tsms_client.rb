module TSMS
end

require 'active_support'
require 'tsms_client/version'
require 'faraday'
require 'link_header'
require 'faraday_middleware'
require 'tsms_client/util/hal_link_parser'
require 'tsms_client/util/core_ext'
require 'tsms_client/connection'
require 'tsms_client/client'
require 'tsms_client/logger'

require 'tsms_client/base'
require 'tsms_client/instance_resource'
require 'tsms_client/collection_resource'
require 'tsms_client/recipients'
require 'tsms_client/recipient'
require 'tsms_client/messages'
require 'tsms_client/message'
require 'tsms_client/messages'
require 'tsms_client/inbound_message'
require 'tsms_client/inbound_messages'
