class Order < ActiveRecord::Base

  attr_accessible :nome, :email, :product_id

  belongs_to :product


  validates :nome,        :presence => true,  :length => {:maximum => 100}
  validates :email,       :presence => true,  :length => {:maximum => 100}
  validates_presence_of :product_id


end
