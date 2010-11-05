class AddInitialUser < ActiveRecord::Migration
  def self.up
    User.create!(:username => "root", :password => "root", :password_confirmation => "root")
  end

  def self.down
  end
end