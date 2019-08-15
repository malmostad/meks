RSpec.describe PeopleHelper, type: :helper do
  before(:each) do
    helper.title('foo')
  end

  it 'h1 be inherited from the title' do
    expect(helper.h1).to eq('foo')
  end

  it 'page_title should be contactenated from title and title_suffix' do
    expect(helper.page_title).to eq("foo - #{helper.title_suffix}")
  end
end
