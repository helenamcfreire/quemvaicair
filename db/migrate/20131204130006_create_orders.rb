class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.string :nome
      t.string :email
      t.references :product

      t.timestamps
    end
  end
end
