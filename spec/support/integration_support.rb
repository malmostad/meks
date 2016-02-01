def create_users_with_roles
  %w(admin writer reader).each do |role|
    get_or_create_user role
  end
end

def get_or_create_user(role)
  user = User.first_or_initialize(username: "#{role}-user", role: role)
  user.save!
  user
end

def current_user(role)
  @current_user ||= get_or_create_user(role)
end

def login(role)
  user = get_or_create_user(role)
  get login_path
  fill_in 'username', with: user.username
  fill_in 'password', with: 'stubbed'
  click_button 'Logga in'
end
