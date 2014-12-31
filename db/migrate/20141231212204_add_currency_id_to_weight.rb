class AddCurrencyIdToWeight < ActiveRecord::Migration
  def change
    add_reference :weight, :currency, index: true
    add_foreign_key :weight, :currencies
  end
end
