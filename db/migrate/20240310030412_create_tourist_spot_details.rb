class CreateTouristSpotDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :tourist_spot_details do |t|
      t.string :language
      t.string :country
      t.string :climate
      t.string :temperature
      t.string :currency
      t.string :currency_symbol
      t.references :tourist_spot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
