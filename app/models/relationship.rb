class Relationship < ActiveRecord::Base

  belongs_to :user, class_name:"User", foreign_key: :donor_id
  belongs_to :user, class_name:"User", foreign_key: :family_id
end
