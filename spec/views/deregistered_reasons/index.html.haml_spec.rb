RSpec.describe 'moved_out_reasons/index', type: :view do
  before(:each) do
    @moved_out_reasons = assign(:moved_out_reasons, create_list(:moved_out_reason, 2))
  end

  it 'renders a list of moved_out_reasons' do
    render
    assert_select 'tr>td', text: @moved_out_reasons.first.name, count: 1
    assert_select 'tr>td', text: @moved_out_reasons.second.name, count: 1
  end
end
