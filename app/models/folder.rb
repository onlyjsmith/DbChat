class Folder < ActiveRecord::Base
  has_many :comments
end
