RSpec.describe 'municipalities/index', type: :view do
  before(:each) do
    @municipalities = assign(:municipalities, create_list(:municipality, 2))
  end

  it 'renders a list of municipalities' do
    render
    assert_select 'tr>td', text: @municipalities.first.name, count: 1
    assert_select 'tr>td', text: @municipalities.second.name, count: 1
  end
end
