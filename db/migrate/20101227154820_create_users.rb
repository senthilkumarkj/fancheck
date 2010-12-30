class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :twitter_id, :null => false
      t.string :oauth_token, :null => false
      t.string :oauth_token_secret, :null => false
      t.string :mode, :null => false, :default => DEFAULT_MODE

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
