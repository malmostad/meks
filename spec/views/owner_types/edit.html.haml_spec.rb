RSpec.describe 'owner_types/edit', type: :view do
  before(:each) do
    @owner_type = assign(:owner_type, create(:owner_type))
  end

  it 'renders the edit owner_type form' do
    render

    assert_select 'form[action=?][method=?]', owner_type_path(@owner_type), 'post' do
      assert_select 'input#owner_type_name[name=?]', 'owner_type[name]'
    end
  end
end
