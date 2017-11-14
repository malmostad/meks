module IntegrationMacros
  def create_users_with_roles
    %w(admin writer reader).each do |role|
      get_or_create_user role
    end
  end

  def get_or_create_user(role = :writer)
    user = User.first_or_initialize(username: "#{role}-user", role: role)
    user.save!
    user
  end

  def current_user(role = :writer)
    @current_user ||= get_or_create_user(role)
  end

  def login_user(role = :writer)
    user = get_or_create_user(role)
    visit login_path
    fill_in 'username', with: user.username
    click_button 'Logga in'
  end

  def valid_session(role: :admin)
    current_user = get_or_create_user(role)
    session[:renewed_at] = Time.now + 1.day
    { user_id: current_user.id }
  end
end
