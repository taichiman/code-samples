require 'active_support/concern'

module Archify
  extend ActiveSupport::Concern

  included do
     state_machine initial: :active do
       before_transition any => :deleted do |obj, transition|
         obj.deleted_at = Time.current
         obj.order_at = 0
       end
       before_transition :deleted => any do |obj, transition|
         obj.deleted_at = nil
       end
       state :active
       state :deleted

       event :restore do
         transition :deleted => :active
       end

       event :mark_as_deleted do
         transition :active => :deleted
       end
     end
  end

end

