class InsertBuiltinRoles < ActiveRecord::Migration
  def self.up
    nonmember = Role.new(:name => 'Non member', :position => 0)
    nonmember.builtin_for_db_migrate(Role::BUILTIN_NON_MEMBER)
    nonmember.save
    
    anonymous = Role.new(:name => 'Anonymous', :position => 0)
    anonymous.builtin_for_db_migrate(Role::BUILTIN_ANONYMOUS)
    anonymous.save  
  end

  def self.down
    Role.destroy_all 'builtin <> 0'
  end
end
