RSpec.describe Refugee, type: :model do
  it 'should be adding one' do
    expect { create(:refugee) }.to change(Refugee, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:refugee)).to be_valid
    end

    it 'should require a name' do
      expect(build(:refugee, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:refugee, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:refugee, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique dossier_number' do
      create(:refugee, dossier_number: '1234')
      expect(build(:refugee, dossier_number: '1234')).not_to be_valid
    end

    it 'should have valid date_of_birth' do
      expect(build(:refugee, date_of_birth: '2016-01-01')).to be_valid
    end

    it 'should not have an invalid date_of_birth' do
      expect(build(:refugee, date_of_birth: '1/1/1')).not_to be_valid
    end

    it 'should have validate_date_of_birth' do
      expect(build(:refugee, date_of_birth: '2016-01-01')).to be_valid
    end

    it '... just checking transactional support' do
      expect(Refugee.count(true)).to eq 0
    end
  end

  describe 'in our_municipality' do
    let(:municipality) { create(:municipality, our_municipality: true) }
    let(:refugee) { create(:refugee, municipality: municipality) }

    it 'should be in our_municipality' do
      expect(refugee.in_our_municipality?).to be true
    end
  end

  describe 'associations' do
    let(:refugee) { create(:refugee) }

    it 'should have a gender' do
      expect(refugee.gender).to be_present
    end

    it 'should know some languages' do
      expect(refugee.languages).to be_present
    end

    it 'should come from a country' do
      expect(refugee.countries).to be_present
    end

    it 'should not have a citizenship_at' do
      expect(refugee.citizenship_at).to be_nil
    end

    it 'should be assigned to a municipality' do
      expect(refugee.municipality).to be_present
    end

    it 'should still be there if her municipality is destroyed' do
      municipality = refugee.municipality
      expect{ municipality.destroy }.to change(Municipality, :count).by(-1)
      expect(refugee).to be_present
    end

    it 'should still be there if her language is destroyed' do
      language = refugee.languages.first
      expect{ language.destroy }.to change(Language, :count).by(-1)
      expect(refugee).to be_present
    end

    it 'should still be there if her country is destroyed' do
      country = refugee.countries.first
      expect{ country.destroy }.to change(Country, :count).by(-1)
      expect(refugee).to be_present
    end
  end

  describe 'assocations should be deleted when the refugee is deleted' do
    let(:refugee) { create(:refugee) }

    it 'countries' do
      country = create(:country)
      refugee.countries = [country]
      expect{ refugee.destroy }.to change(country.refugees, :count).by(-1)
    end

    it 'languages' do
      language = create(:language)
      refugee.languages = [language]
      expect{ refugee.destroy }.to change(language.refugees, :count).by(-1)
    end

    it 'ssn' do
      create(:ssn, refugee: refugee)
      refugee.reload
      expect{ refugee.destroy }.to change(Ssn, :count).by(-1)
    end

    it 'dossier_numbers' do
      create(:dossier_number, refugee: refugee)
      refugee.reload
      expect{ refugee.destroy }.to change(DossierNumber, :count).by(-1)
    end

    it 'placements' do
      create_list(:placement, 2, refugee: refugee)
      number_of_placements = refugee.placements.size
      expect{ refugee.destroy }.to change(Placement, :count).by(- number_of_placements)
    end

    it 'relationships' do
      create_list(:relationship, 2, refugee: refugee)
      number_of_relationships = refugee.relationships.size
      expect{ refugee.destroy }.to change(Relationship, :count).by(- number_of_relationships)
    end

    it 'inverse_relationships' do
      create_list(:relationship, 2, related: refugee)
      number_of_inverse_relationships = refugee.inverse_relationships.size
      expect{ refugee.destroy }.to change(Relationship, :count).by(- number_of_inverse_relationships)
    end

    it 'inverse_relateds' do
      create(:relationship, related: refugee)
      expect{ refugee.inverse_relateds.first.destroy }.to change(Relationship, :count).by(-1)
    end
  end

  describe 'deletetion of assocations should not delete refugees' do
    let(:refugee) { create(:refugee) }

    it 'countries' do
      country = create(:country)
      refugee.countries = [country]
      expect{ country.destroy }.not_to change(Refugee, :count)
    end

    it 'languages' do
      language = create(:language)
      refugee.languages = [language]
      expect{ language.destroy }.not_to change(Refugee, :count)
    end

    it 'ssn' do
      ssn = create(:ssn, refugee: refugee)
      refugee.reload
      expect{ ssn.destroy }.not_to change(Refugee, :count)
    end

    it 'dossier_numbers' do
      dossier_number = create(:dossier_number, refugee: refugee)
      refugee.reload
      expect{ dossier_number.destroy }.not_to change(Refugee, :count)
    end

    it 'placements' do
      placements = create_list(:placement, 2, refugee: refugee)
      expect{ placements.first.destroy }.not_to change(Refugee, :count)
      expect{ placements.each(&:destroy) }.not_to change(Refugee, :count)
    end

    it 'relationships' do
      relationships = create_list(:relationship, 2, refugee: refugee)
      expect{ relationships.first.destroy }.not_to change(Refugee, :count)
      expect{ relationships.each(&:destroy) }.not_to change(Refugee, :count)
    end

    it 'inverse_relationships' do
      create_list(:relationship, 2, refugee: refugee)
      expect{ refugee.relationships.first.destroy }.not_to change(Refugee, :count)
      expect{ refugee.relationships.destroy_all }.not_to change(Refugee, :count)
    end
  end

  describe 'delete relateds should delete refugees' do
    let(:refugee) { create(:refugee) }

    it 'relateds' do
      create_list(:relationship, 10, refugee: refugee)
      expect{ refugee.relateds.first.destroy }.to change(Refugee, :count).by(-1)
      expect{ refugee.relateds.each(&:destroy) }.to change(Refugee, :count).by(-9)
    end

    it 'inverse_relateds' do
      create_list(:relationship, 10, related: refugee)
      expect{ refugee.inverse_relateds.first.destroy }.to change(Refugee, :count).by(-1)
      expect{ refugee.inverse_relateds.each(&:destroy) }.to change(Refugee, :count).by(-9)
    end
  end

  describe 'extended deletion integrity checks' do
    let(:refugee) { create(:refugee) }

    it 'ssns' do
      ssns = refugee.ssns = create_list(:ssn, 3, refugee: refugee)
      total_ssns = Ssn.count
      expect(refugee.ssns).to be_present
      expect { ssns.each { |s| s.destroy } }.to change(Ssn, :count).by(-3)
      refugee.reload
      expect(refugee.ssns).to be_empty
      expect(refugee).to be_present
    end

    it 'dossier_numbers' do
      dossier_numbers = refugee.dossier_numbers = create_list(:dossier_number, 3, refugee: refugee)
      total_dossier_numbers = DossierNumber.count
      expect(refugee.dossier_numbers).to be_present
      expect { dossier_numbers.each { |s| s.destroy } }.to change(DossierNumber, :count).by(-3)
      refugee.reload
      expect(refugee.dossier_numbers).to be_empty
      expect(refugee).to be_present
    end
  end

  describe 'placements' do
    let(:refugee) { create(:refugee) }

    before(:each) {
      refugee.placements << create(:placement, refugee: refugee)
    }

    it 'should have a placement' do
      expect(refugee.placements).to be_present
    end

    it 'should have a current_placements' do
      expect(refugee.current_placements.size).to eq(1)
    end

    it 'should have a moved in date' do
      expect(refugee.placements.first.moved_in_at).to be_a(Date)
    end

    it 'should not have a placement after the home is deleted' do
      home = refugee.placements.first.home
      home.destroy
      refugee.reload
      expect(refugee.placements).not_to be_present
    end

    it 'the placement should not persist if the refugee is deleted' do
      home = refugee.placements.first.home
      refugee.destroy
      home.reload
      expect(home.placements).not_to be_present
      expect(home.current_placements).not_to be_present
    end

    it 'the refugee should not have any placements if the placement is deleted' do
      placement = refugee.placements.first
      placement.destroy
      refugee.reload
      expect(refugee.placements).not_to be_present
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:refugee, name: 'Refugee name') }.to change(Refugee, :count).by(+1)
      expect { Refugee.where(name: 'Refugee name').first.destroy }.to change(Refugee, :count).by(-1)
    end
  end
end
