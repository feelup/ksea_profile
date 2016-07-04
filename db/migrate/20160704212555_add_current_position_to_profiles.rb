class AddCurrentPositionToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :title, :string
    add_column :profiles, :affiliation, :string
  end
end
