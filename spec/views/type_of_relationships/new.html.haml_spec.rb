RSpec.describe 'type_of_relationships/new', type: :view do
  before(:each) do
    assign(:type_of_relationship, build(:type_of_relationship))
  end

  it 'renders new type_of_relationship form' do
    render

    assert_select 'form[action=?][method=?]', type_of_relationships_path, 'post' do
      assert_select 'input#type_of_relationship_name[name=?]', 'type_of_relationship[name]'
    end
  end
end
