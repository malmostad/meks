RSpec.describe 'target_groups/index', type: :view do
  before(:each) do
    @target_groups = assign(:target_groups, create_list(:target_group, 2))
  end

  it 'renders a list of target_groups' do
    render
    assert_select 'tr>td', text: @target_groups.first.name, count: 1
    assert_select 'tr>td', text: @target_groups.second.name, count: 1
  end
end
