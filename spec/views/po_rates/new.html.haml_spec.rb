RSpec.describe 'po_rates/new', type: :view do
  before(:each) do
    assign(:po_rate, build(:po_rate))
  end

  it 'renders new po_rate form' do
    render

    assert_select 'form[action=?][method=?]', po_rates_path, 'post' do
      assert_select 'input#po_rate_start_date[name=?]', 'po_rate[start_date]'
      assert_select 'input#po_rate_end_date[name=?]', 'po_rate[end_date]'
      assert_select 'input#po_rate_rate_under_65[name=?]', 'po_rate[rate_under_65]'
      assert_select 'input#po_rate_rate_between_65_and_81[name=?]', 'po_rate[rate_between_65_and_81]'
      assert_select 'input#po_rate_rate_from_82[name=?]', 'po_rate[rate_from_82]'
    end
  end
end
