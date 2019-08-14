RSpec.describe 'type_of_housings/index', type: :view do
  before(:each) do
    @type_of_housings = assign(:type_of_housings, create_list(:type_of_housing, 2))
  end

  it 'renders a list of type_of_housings' do
    render
    assert_select 'tr>td', text: @type_of_housings.first.name, count: 1
    assert_select 'tr>td', text: @type_of_housings.second.name, count: 1
  end
end
