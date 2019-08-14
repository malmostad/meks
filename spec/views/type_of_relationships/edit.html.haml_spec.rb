RSpec.describe 'type_of_relationships/edit', type: :view do
  before(:each) do
    @type_of_relationship = assign(:type_of_relationship, create(:type_of_relationship))
  end

  it 'renders the edit type_of_relationship form' do
    render

    assert_select 'form[action=?][method=?]', type_of_relationship_path(@type_of_relationship), 'post' do
      assert_select 'input#type_of_relationship_name[name=?]', 'type_of_relationship[name]'
    end
  end
end
