module TSMS
  class Recipient
    include InstanceResource

    writeable_attributes :phone
    readonly_attributes :formatted_phone, :error_message, :status
  end
end