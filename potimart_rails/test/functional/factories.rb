  # This will guess the User class
  Factory.define :user do |u|
    u.first_name 'John'
    u.last_name  'Doe'
    u.admin false
  end

  # This will use the User class (Admin would have been guessed)
  Factory.define :admin, :class => User do |u|
    u.first_name 'Admin'
    u.last_name  'User'
    u.admin true
  end

  # The same, but using a string instead of class constant
  Factory.define :admin, :class => 'user' do |u|
    u.first_name 'Admin'
    u.last_name  'User'
    u.admin true
  end
