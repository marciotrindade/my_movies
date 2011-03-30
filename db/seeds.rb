# rights from routes
Right.populate_from_routes

# roles
role = Role.find_or_create_by_name("Admin")
role.rights = Right.all
role.save

# users
users = []
users << {:name => "Admin", :email => "admin@admin.com", :username => "admin", :password => "admin", :password_confirmation => "admin"}
users.each do |user|
  User.create(user) if User.find_by_username(user[:username]).blank?
end

# set a user as admin
user = User.find_by_username("admin")
user.roles = [Role.find_by_name("Admin")]
