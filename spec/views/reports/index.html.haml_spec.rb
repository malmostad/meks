RSpec.describe 'reports/index', type: :view do
  before(:each) do
    assign(:homes, create_list(:home, 2))
    assign(:our_municipalities, create_list(:municipality, 2))
    assign(:pre_generated_reports, [])
  end

  it 'renders a list of report forms' do
    render
    assert_select 'h2', text: 'Placeringar'.to_s, count: 1
    assert_select 'h2', text: 'Personer'.to_s, count: 1
    assert_select 'select#people_asylum', name: 'people_asylum'.to_s, count: 1
    assert_select 'h2', text: 'Boenden'.to_s, count: 1
  end
end
