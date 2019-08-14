module IntegrationMacros
  def label(name)
    I18n.t("simple_form.labels.#{name}")
  end

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

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    find("##{field[:id]}_chosen").click
    find("##{field[:id]}_chosen ul.chosen-results li", text: item_text).click
  end
end
