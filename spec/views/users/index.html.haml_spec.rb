RSpec.describe 'users/index', type: :view do
  before(:each) do
    @users = assign(:users, create_list(:user, 2))
  end

  it 'renders a list of type_of_relationships' do
    render
    assert_select 'tr>td', text: @users.first.name, count: 1
    assert_select 'tr>td', text: @users.second.name, count: 1
  end
end
