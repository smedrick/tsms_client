module TSMS
  class Recipient
    include InstanceResource

    writeable_attributes :country_code, :phone
    readonly_attributes :provided_country_code, :provided_phone, :error_message, :status
  end
end