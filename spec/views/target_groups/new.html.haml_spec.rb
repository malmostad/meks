RSpec.describe 'target_groups/new', type: :view do
  before(:each) do
    assign(:target_group, build(:target_group))
  end

  it 'renders new target_group form' do
    render

    assert_select 'form[action=?][method=?]', target_groups_path, 'post' do
      assert_select 'input#target_group_name[name=?]', 'target_group[name]'
    end
  end
end
