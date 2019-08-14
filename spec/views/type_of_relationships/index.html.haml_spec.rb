RSpec.describe 'type_of_relationships/index', type: :view do
  before(:each) do
    @type_of_relationships = assign(:type_of_relationships, create_list(:type_of_relationship, 2))
  end

  it 'renders a list of type_of_relationships' do
    render
    assert_select 'tr>td', text: @type_of_relationships.first.name, count: 1
    assert_select 'tr>td', text: @type_of_relationships.second.name, count: 1
  end
end
