RSpec.describe Language, type: :model do
  it 'should be adding one' do
    expect { create(:language) }.to change(Language, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:language)).to be_valid
    end

    it 'should require a name' do
      expect(build(:language, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:language, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:language, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique name' do
      create(:language, name: 'Svenska')
      expect(build(:language, name: 'Svenska')).not_to be_valid
    end

    it '... just checking transactional support' do
      expect(Language.count).to eq 0
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:language, name: 'Svenska') }.to change(Language, :count).by(+1)
      expect { Language.where(name: 'Svenska').first.destroy }.to change(Language, :count).by(-1)
    end

    it 'should delete a language reference for a person' do
      language = create(:language)
      person = create(:person, languages: [language])
      expect(person.languages).not_to be_empty
      language.destroy
      person.reload
      expect(person.languages).to be_empty
    end
  end
end
