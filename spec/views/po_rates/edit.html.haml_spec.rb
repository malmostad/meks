RSpec.describe 'po_rates/edit', type: :view do
  before(:each) do
    @po_rate = assign(:po_rate, create(:po_rate))
  end

  it 'renders the edit po_rate form' do
    render
    assert_select 'form[action=?][method=?]', po_rate_path(@po_rate), 'post' do
      assert_select 'input#po_rate_start_date[name=?]', 'po_rate[start_date]'
      assert_select 'input#po_rate_end_date[name=?]', 'po_rate[end_date]'
      assert_select 'input#po_rate_rate_under_65[name=?]', 'po_rate[rate_under_65]'
      assert_select 'input#po_rate_rate_between_65_and_81[name=?]', 'po_rate[rate_between_65_and_81]'
      assert_select 'input#po_rate_rate_from_82[name=?]', 'po_rate[rate_from_82]'
    end
  end
end
