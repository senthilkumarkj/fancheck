class CreateFanChecks < ActiveRecord::Migration
  def self.up
    create_table :fan_checks do |t|
      t.string :twitter_id, :null => false
      t.string :user_a, :null => false
      t.string :user_b, :null => false
      t.boolean :valid_a, :null => false
      t.boolean :valid_b, :null => false
      t.string :user_a_id
      t.string :user_b_id
      t.boolean :protected_a
      t.boolean :protected_b
      t.boolean :verified_a
      t.boolean :verified_b
      t.string :user_a_dp
      t.string :user_b_dp
      t.boolean :a_fan_of_b
      t.boolean :b_fan_of_a
      t.boolean :a_b_friends
      t.integer :state, :length => 2
      t.datetime :checked_at, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :fan_checks
  end
end
