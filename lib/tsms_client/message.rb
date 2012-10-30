module TSMS
  class Message
    include InstanceResource

    writeable_attributes :short_body
    readonly_attributes :created_at, :completed_at
    collection_attributes :recipients
  end
end