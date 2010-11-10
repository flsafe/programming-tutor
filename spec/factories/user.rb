Factory.sequence :email do |n|
  "user#{n}@mail.com"
end

Factory.sequence :username do |n|
  "user #{n}"
end

Factory.define :user do |u|
  u.username {Factory.next :username}
  u.password 'password'
  u.password_confirmation 'password'
  u.email {Factory.next :email}
  u.anonymous false
end
