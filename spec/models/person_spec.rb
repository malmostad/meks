RSpec.describe Person, type: :model do
  it 'should be adding one' do
    expect { create(:person) }.to change(Person, :count).by(+1)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(build(:person)).to be_valid
    end

    it 'should require a name' do
      expect(build(:person, name: nil)).not_to be_valid
    end

    it 'should be valid with a not too long name' do
      expect(build(:person, name: 'x' * 191)).to be_valid
    end

    it 'should not have a too long name' do
      expect(build(:person, name: 'x' * 192)).not_to be_valid
    end

    it 'should have a unique dossier_number' do
      create(:person, dossier_number: '1234')
      expect(build(:person, dossier_number: '1234')).not_to be_valid
    end

    it 'should have valid date_of_birth' do
      expect(build(:person, date_of_birth: '2016-01-01')).to be_valid
    end

    it 'should not have an invalid date_of_birth' do
      expect(build(:person, date_of_birth: '1/1/1')).not_to be_valid
    end

    it 'should have validate_date_of_birth' do
      expect(build(:person, date_of_birth: '2016-01-01')).to be_valid
    end

    it '... just checking transactional support' do
      expect(Person.count(true)).to eq 0
    end
  end

  describe 'in our_municipality' do
    let(:municipality) { create(:municipality, our_municipality: true) }
    let(:person) { create(:person, municipality: municipality) }

    it 'should be in our_municipality' do
      expect(person.in_our_municipality?).to be true
    end
  end

  describe 'associations' do
    let(:person) { create(:person) }

    it 'should have a gender' do
      expect(person.gender).to be_present
    end

    it 'should know some languages' do
      expect(person.languages).to be_present
    end

    it 'should come from a country' do
      expect(person.countries).to be_present
    end

    it 'should not have a citizenship_at' do
      expect(person.citizenship_at).to be_nil
    end

    it 'should be assigned to a municipality' do
      expect(person.municipality).to be_present
    end

    it 'should still be there if her municipality is destroyed' do
      municipality = person.municipality
      expect{ municipality.destroy }.to change(Municipality, :count).by(-1)
      expect(person).to be_present
    end

    it 'should still be there if her language is destroyed' do
      language = person.languages.first
      expect{ language.destroy }.to change(Language, :count).by(-1)
      expect(person).to be_present
    end

    it 'should still be there if her country is destroyed' do
      country = person.countries.first
      expect{ country.destroy }.to change(Country, :count).by(-1)
      expect(person).to be_present
    end
  end

  describe 'assocations should be deleted when the person is deleted' do
    let(:person) { create(:person) }

    it 'countries' do
      country = create(:country)
      person.countries = [country]
      expect{ person.destroy }.to change(country.people, :count).by(-1)
    end

    it 'languages' do
      language = create(:language)
      person.languages = [language]
      expect{ person.destroy }.to change(language.people, :count).by(-1)
    end

    it 'ssn' do
      create(:ssn, person: person)
      person.reload
      expect{ person.destroy }.to change(Ssn, :count).by(-1)
    end

    it 'dossier_numbers' do
      create(:dossier_number, person: person)
      person.reload
      expect{ person.destroy }.to change(DossierNumber, :count).by(-1)
    end

    it 'placements' do
      create_list(:placement, 2, person: person)
      number_of_placements = person.placements.size
      expect{ person.destroy }.to change(Placement, :count).by(- number_of_placements)
    end

    it 'relationships' do
      create_list(:relationship, 2, person: person)
      number_of_relationships = person.relationships.size
      expect{ person.destroy }.to change(Relationship, :count).by(- number_of_relationships)
    end

    it 'inverse_relationships' do
      create_list(:relationship, 2, related: person)
      number_of_inverse_relationships = person.inverse_relationships.size
      expect{ person.destroy }.to change(Relationship, :count).by(- number_of_inverse_relationships)
    end

    it 'inverse_relateds' do
      create(:relationship, related: person)
      expect{ person.inverse_relateds.first.destroy }.to change(Relationship, :count).by(-1)
    end
  end

  describe 'deletetion of assocations should not delete people' do
    let(:person) { create(:person) }

    it 'countries' do
      country = create(:country)
      person.countries = [country]
      expect{ country.destroy }.not_to change(Person, :count)
    end

    it 'languages' do
      language = create(:language)
      person.languages = [language]
      expect{ language.destroy }.not_to change(Person, :count)
    end

    it 'ssn' do
      ssn = create(:ssn, person: person)
      person.reload
      expect{ ssn.destroy }.not_to change(Person, :count)
    end

    it 'dossier_numbers' do
      dossier_number = create(:dossier_number, person: person)
      person.reload
      expect{ dossier_number.destroy }.not_to change(Person, :count)
    end

    it 'placements' do
      placements = create_list(:placement, 2, person: person)
      expect{ placements.first.destroy }.not_to change(Person, :count)
      expect{ placements.each(&:destroy) }.not_to change(Person, :count)
    end

    it 'relationships' do
      relationships = create_list(:relationship, 2, person: person)
      expect{ relationships.first.destroy }.not_to change(Person, :count)
      expect{ relationships.each(&:destroy) }.not_to change(Person, :count)
    end

    it 'inverse_relationships' do
      create_list(:relationship, 2, person: person)
      expect{ person.relationships.first.destroy }.not_to change(Person, :count)
      expect{ person.relationships.destroy_all }.not_to change(Person, :count)
    end
  end

  describe 'delete relateds should delete people' do
    let(:person) { create(:person) }

    it 'relateds' do
      create_list(:relationship, 10, person: person)
      expect{ person.relateds.first.destroy }.to change(Person, :count).by(-1)
      expect{ person.relateds.each(&:destroy) }.to change(Person, :count).by(-9)
    end

    it 'inverse_relateds' do
      create_list(:relationship, 10, related: person)
      expect{ person.inverse_relateds.first.destroy }.to change(Person, :count).by(-1)
      expect{ person.inverse_relateds.each(&:destroy) }.to change(Person, :count).by(-9)
    end
  end

  describe 'extended deletion integrity checks' do
    let(:person) { create(:person) }

    it 'ssns' do
      ssns = person.ssns = create_list(:ssn, 3, person: person)
      total_ssns = Ssn.count
      expect(person.ssns).to be_present
      expect { ssns.each { |s| s.destroy } }.to change(Ssn, :count).by(-3)
      person.reload
      expect(person.ssns).to be_empty
      expect(person).to be_present
    end

    it 'dossier_numbers' do
      dossier_numbers = person.dossier_numbers = create_list(:dossier_number, 3, person: person)
      total_dossier_numbers = DossierNumber.count
      expect(person.dossier_numbers).to be_present
      expect { dossier_numbers.each { |s| s.destroy } }.to change(DossierNumber, :count).by(-3)
      person.reload
      expect(person.dossier_numbers).to be_empty
      expect(person).to be_present
    end
  end

  describe 'placements' do
    let(:person) { create(:person) }

    before(:each) {
      person.placements << create(:placement, person: person)
    }

    it 'should have a placement' do
      expect(person.placements).to be_present
    end

    it 'should have a current_placements' do
      expect(person.current_placements.size).to eq(1)
    end

    it 'should have a moved in date' do
      expect(person.placements.first.moved_in_at).to be_a(Date)
    end

    it 'should not have a placement after the home is deleted' do
      home = person.placements.first.home
      home.destroy
      person.reload
      expect(person.placements).not_to be_present
    end

    it 'the placement should not persist if the person is deleted' do
      home = person.placements.first.home
      person.destroy
      home.reload
      expect(home.placements).not_to be_present
      expect(home.current_placements).not_to be_present
    end

    it 'the person should not have any placements if the placement is deleted' do
      placement = person.placements.first
      placement.destroy
      person.reload
      expect(person.placements).not_to be_present
    end
  end

  describe 'EKB attributes' do
    let(:person) do
      create(
        :person,
        ekb: true,
        special_needs: true,
        residence_permit_at: '2019-01-01',
        checked_out_to_our_city: '2019-01-01',
        temporary_permit_starts_at: '2019-01-01',
        temporary_permit_ends_at: '2019-01-01',
        citizenship_at: '2019-01-01',
        transferred: true,
        municipality_placement_migrationsverket_at: '2019-01-01',
        municipality_placement_comment: 'foo',
        deregistered_reason: create(:deregistered_reason)
      )
    end

    it 'should be saved' do
      expect(person.special_needs).to be_truthy
      expect(person.residence_permit_at).to be_present
      expect(person.checked_out_to_our_city).to be_present
      expect(person.temporary_permit_starts_at).to be_present
      expect(person.temporary_permit_ends_at).to be_present
      expect(person.citizenship_at).to be_present
      expect(person.transferred).to be_truthy
      expect(person.municipality_placement_migrationsverket_at).to be_present
      expect(person.municipality_placement_comment).to be_present
      expect(person.deregistered_reason).to be_present
    end

    it 'should be cleared when not EKB' do
      person.update_attribute(:ekb, false)
      person.reload

      expect(person.ssns).to be_empty
      expect(person.dossier_numbers).to be_empty
      expect(person.special_needs).to be_nil
      expect(person.residence_permit_at).to be_nil
      expect(person.checked_out_to_our_city).to be_nil
      expect(person.temporary_permit_starts_at).to be_nil
      expect(person.temporary_permit_ends_at).to be_nil
      expect(person.citizenship_at).to be_nil
      expect(person.transferred).to be_nil
      expect(person.municipality_placement_migrationsverket_at).to be_nil
      expect(person.municipality_placement_comment).to be_nil
      expect(person.deregistered_reason).to be_nil
    end
  end

  describe 'destroy' do
    it 'should destroy a record' do
      expect { create(:person, name: 'Person name') }.to change(Person, :count).by(+1)
      expect { Person.where(name: 'Person name').first.destroy }.to change(Person, :count).by(-1)
    end
  end
end
