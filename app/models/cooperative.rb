class Cooperative < ActiveRecord::Base
  # has_many :jobs, through: :members
  # has_many :contacteds, through: :members
  has_many :users
  has_many :members

  validates_presence_of :name

end
