class AddFollowersCountColumns < ActiveRecord::Migration
  def self.up
   add_column :fan_checks, :followers_count_a, :integer
   add_column :fan_checks, :followers_count_b, :integer
  end

  def self.down
   remove_column :fan_checks, :followers_count_a
   remove_column :fan_checks, :followers_count_b
  end
end
