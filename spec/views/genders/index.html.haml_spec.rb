RSpec.describe 'genders/index', type: :view do
  before(:each) do
    @genders = assign(:genders, create_list(:gender, 2))
  end

  it 'renders a list of genders' do
    render
    assert_select 'tr>td', text: @genders.first.name, count: 1
    assert_select 'tr>td', text: @genders.second.name, count: 1
  end
end
