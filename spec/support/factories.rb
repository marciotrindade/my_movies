Factory.sequence :name do |n|
  "Name number #{n}"
end

Factory.sequence :login do |n|
  "user#{n}"
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :number do |n|
  n
end

Factory.define :user do |f|
  f.username { Factory.next(:login) }
  f.email { Factory.next(:email) }
  f.name 'User'
  f.password 'secret'
  f.password_confirmation 'secret'
end

Factory.define :role do |f|
  f.name 'role name'
end
