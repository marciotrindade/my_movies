class Role < ActiveRecord::Base
  
  validates_presence_of :name
  has_and_belongs_to_many :rights
  has_and_belongs_to_many :users

  default_scope :order => "roles.name"

end
