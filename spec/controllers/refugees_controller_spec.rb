require 'rails_helper'

RSpec.describe RefugeesController, type: :controller do

  let(:valid_attributes) {
    {
      name: "Firstname Lastname",
      date_of_birth: "2016-01-01",
      ssn_extension: "1234"
    }
  }

  let(:invalid_attributes) {
    {
      name: "Firstname Lastname",
      date_of_birth: "2016-01-xx",
      ssn_extension: "1234"
    }
  }

  describe "GET #drafts" do
    it "assigns all refugees as @refugees" do
      refugee = Refugee.create! valid_attributes.merge(draft: true)
      get :drafts, {}, valid_session
      expect(assigns(:refugees)).to eq([refugee])
    end
  end

  describe "GET #show" do
    it "assigns the requested refugee as @refugee" do
      refugee = Refugee.create! valid_attributes
      get :show, {:id => refugee.to_param}, valid_session
      expect(assigns(:refugee)).to eq(refugee)
    end
  end

  describe "GET #new" do
    it "assigns a new refugee as @refugee" do
      get :new, {}, valid_session
      expect(assigns(:refugee)).to be_a_new(Refugee)
    end
  end

  describe "GET #edit" do
    it "assigns the requested refugee as @refugee" do
      refugee = Refugee.create! valid_attributes
      get :edit, {:id => refugee.to_param}, valid_session
      expect(assigns(:refugee)).to eq(refugee)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Refugee" do
        expect {
          post :create, {:refugee => valid_attributes}, valid_session
        }.to change(Refugee, :count).by(1)
      end

      it "assigns a newly created refugee as @refugee" do
        post :create, {:refugee => valid_attributes}, valid_session
        expect(assigns(:refugee)).to be_a(Refugee)
        expect(assigns(:refugee)).to be_persisted
      end

      it "redirects to the created refugee" do
        post :create, {:refugee => valid_attributes}, valid_session
        expect(response).to redirect_to(Refugee.last)
      end

      it "make @refugee a draft if reader role" do
        post :create, {:refugee => valid_attributes}, valid_session(role: :reader)
        expect(Refugee.last.draft).to eq(true)
      end

      it "don't make @refugee a draft if writer role" do
        post :create, {:refugee => valid_attributes}, valid_session(role: :writer)
        expect(Refugee.last.draft).to eq(false)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved refugee as @refugee" do
        post :create, {:refugee => invalid_attributes}, valid_session
        expect(assigns(:refugee)).to be_a_new(Refugee)
      end

      it "re-renders the 'new' template" do
        post :create, {:refugee => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name: "Firstname Lastname updated",
          date_of_birth: "2016-01-02",
          ssn_extension: "1235",
          dossier_number: "1234567"
        }
      }

      it "updates the requested refugee" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => new_attributes}, valid_session
        refugee.reload
        expect(refugee.name).to eq(new_attributes[:name])
        expect(refugee.date_of_birth.to_date.to_s).to eq(new_attributes[:date_of_birth])
        expect(refugee.ssn_extension.to_s).to eq(new_attributes[:ssn_extension])
        expect(refugee.dossier_number).to eq(new_attributes[:dossier_number])
      end

      it "assigns the requested refugee as @refugee" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => valid_attributes}, valid_session
        expect(assigns(:refugee)).to eq(refugee)
      end

      it "redirects to the refugee" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => valid_attributes}, valid_session
        expect(response).to redirect_to(refugee)
      end
    end

    context "with invalid params" do
      it "assigns the refugee as @refugee" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => invalid_attributes}, valid_session
        expect(assigns(:refugee)).to eq(refugee)
      end

      it "re-renders the 'edit' template" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end

      it "re-renders the 'edit' template if ssn_extension is invalid" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => { ssn_extension: "12345" } }, valid_session
        expect(response).to render_template("edit")
      end

      it "re-renders the 'edit' template if date_of_birth is invalid" do
        refugee = Refugee.create! valid_attributes
        put :update, {:id => refugee.to_param, :refugee => { date_of_birth: "2016-01-xx" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'Placement nested attributes' do
    let(:home) {
      Home.create!(name: "Valid home")
    }

    let(:placement_attributes) {
      {
        name: "Firstname Lastname updated",
        placements: {
          home_id: 1,
          moved_in_at: '2016-01-02'
        }
      }
    }

    it "new refugee to have a placement" do
      attributes = {
        name: "Firstname Lastname",
        placements_attributes: [{
          home_id: home.id,
          moved_in_at: '2016-01-02'
        }]
      }
      post :create, { :refugee => attributes }, valid_session
      expect(assigns(:refugee)).to be_persisted
      expect(Refugee.last.placements.size).to eq(1)
    end

    it "new refugee not to have a placement" do
      attributes = {
        name: "Firstname Lastname",
        placements_attributes: []
      }
      post :create, { :refugee => attributes }, valid_session
      expect(assigns(:refugee)).to be_persisted
      expect(Refugee.last.placements.size).to eq(0)
    end

    it "re-renders the 'new' template if placement home_id is present but not moved_in_at" do
      attributes = {
        name: "Firstname Lastname",
        placements_attributes: [{
          home_id: home.id
        }]
      }
      post :create, { refugee: attributes }, valid_session
      expect(response).to render_template("new")
    end

    it "re-renders the 'new' template if placement home_id is abscent but moved_in_at is present" do
      attributes = {
        name: "Firstname Lastname",
        placements_attributes: [{
          moved_in_at: '2016-01-02'
        }]
      }
      post :create, { refugee: attributes }, valid_session
      expect(response).to render_template("new")
    end
  end
end
