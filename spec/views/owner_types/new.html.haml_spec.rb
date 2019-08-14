RSpec.describe 'owner_types/new', type: :view do
  before(:each) do
    assign(:owner_type, build(:owner_type))
  end

  it 'renders new owner_type form' do
    render

    assert_select 'form[action=?][method=?]', owner_types_path, 'post' do
      assert_select 'input#owner_type_name[name=?]', 'owner_type[name]'
    end
  end
end
