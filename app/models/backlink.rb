class Backlink < ApplicationRecord
  belongs_to :backlink_from, :foreign_key => "from_id", :class_name => "Host"
  belongs_to :backlink_to, :foreign_key => "to_id", :class_name => "Host"
end