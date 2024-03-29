# app/models/extensions/uuid.rb
#
module Extensions
  module UUID
    extend ActiveSupport::Concern

    included do
      set_primary_key 'uuid'
      before_create :generate_uuid
      
      def generate_uuid
        self.uuid ||= UUIDTools::UUID.random_create.to_s
      end
    end
  end
end