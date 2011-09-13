class Rails3Repositories < ActiveRecord::Migration
  def self.up
    add_column :repositories, :type_rails2, :string
    Repository.find(:all).each do |repo|
      type_rails2 = repo.type
      repo.update_attribute(:type_rails2, type_rails2)
      repo.update_attribute(:type, "Repository::" + type_rails2)
    end
  end

  def self.down
    Repository.find(:all).each do |repo|
      repo.update_attribute(:type, repo.type_rails2)
    end
    remove_column :repositories, :type_rails2
  end
end
