RSpec.describe 'countries/index', type: :view do
  before(:each) do
    @countries = assign(:countries, create_list(:country, 2))
  end

  it 'renders a list of countries' do
    render
    assert_select 'tr>td', text: @countries.first.name, count: 1
    assert_select 'tr>td', text: @countries.second.name, count: 1
  end
end
