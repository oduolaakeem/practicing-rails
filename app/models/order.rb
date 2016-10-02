class Order < ApplicationRecord
  enum pay_type: {
    'Check' =>          0,
    'Credit Card' =>    1,
    'Purchase Order' => 2
  }

  validates :name, :email, :address, presence: true
  validates :pay_type, inclusion: pay_types.keys
end
