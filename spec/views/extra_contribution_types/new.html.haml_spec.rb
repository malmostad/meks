RSpec.describe 'extra_contribution_types/new', type: :view do
  before(:each) do
    assign(:extra_contribution_type, build(:extra_contribution_type))
  end

  it 'renders new extra_contribution_type form' do
    render

    assert_select 'form[action=?][method=?]', extra_contribution_types_path, 'post' do
      assert_select 'input#extra_contribution_type_name[name=?]', 'extra_contribution_type[name]'
    end
  end
end
