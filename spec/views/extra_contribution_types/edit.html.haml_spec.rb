RSpec.describe 'extra_contribution_types/edit', type: :view do
  before(:each) do
    @extra_contribution_type = assign(:extra_contribution_type, create(:extra_contribution_type))
  end

  it 'renders the edit extra_contribution_type form' do
    render

    assert_select 'form[action=?][method=?]', extra_contribution_type_path(@extra_contribution_type), 'post' do
      assert_select 'input#extra_contribution_type_name[name=?]', 'extra_contribution_type[name]'
    end
  end
end
