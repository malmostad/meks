require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:refugee) {
    Refugee.create!(name: "Refugee")
  }

  let(:related_refugee) {
    Refugee.create!(name: "Related refugee")
  }

  let(:type_of_relationship) {
    TypeOfRelationship.create!(name: "Sister")
  }

  let(:valid_attributes) {
    {
      refugee_id: refugee.id,
      related_id: related_refugee.id,
      type_of_relationship_id: type_of_relationship.id
    }
  }

  let(:invalid_attributes) {
    {
      refugee_id: refugee.id,
      related_id: related_refugee.id,
      type_of_relationship_id: nil
    }
  }

  describe "GET #new" do
    it "assigns a new relationship as @relationship" do
      get :new, { refugee_id: refugee.id }, valid_session
      expect(assigns(:relationship)).to be_a_new(Relationship)
    end
  end

  describe "GET #edit" do
    it "assigns the requested relationship as @relationship" do
      relationship = Relationship.create! valid_attributes
      get :edit, {refugee_id: refugee.id, :id => relationship.to_param}, valid_session
      expect(assigns(:relationship)).to eq(relationship)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Relationship" do
        expect {
          post :create, {refugee_id: refugee.id, :relationship => valid_attributes}, valid_session
        }.to change(Relationship, :count).by(1)
      end

      it "assigns a newly created relationship as @relationship" do
        post :create, {refugee_id: refugee.id, :relationship => valid_attributes}, valid_session
        expect(assigns(:relationship)).to be_a(Relationship)
        expect(assigns(:relationship)).to be_persisted
      end

      it "redirects to the show refugee" do
        post :create, {refugee_id: refugee.id, :relationship => valid_attributes}, valid_session
        expect(response).to redirect_to(refugee_path(refugee))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved relationship as @relationship" do
        post :create, {refugee_id: refugee.id, :relationship => invalid_attributes}, valid_session
        expect(assigns(:relationship)).to be_a_new(Relationship)
      end

      it "re-renders the 'new' template" do
        post :create, {refugee_id: refugee.id, :relationship => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "Inverse relationship" do
    it "assigns a newly created relationship as @relationship" do
      post :create, {refugee_id: refugee.id, :relationship => valid_attributes}, valid_session
      expect(related_refugee.inverse_relationships.first).to be_a(Relationship)
    end

    it "creates a new inverse related" do
      expect {
        post :create, {refugee_id: refugee.id, :relationship => valid_attributes}, valid_session
      }.to change(related_refugee.inverse_relateds, :count).by(1)
    end

    it "creates a new inverse relationship" do
      expect {
        post :create, {refugee_id: refugee.id, :relationship => valid_attributes}, valid_session
      }.to change(related_refugee.inverse_relationships, :count).by(1)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:related_refugee_2) {
        Refugee.create!(name: "Another related refugee")
      }

      let(:type_of_relationship_2) {
        TypeOfRelationship.create!(name: "Brother")
      }

      let(:new_attributes) {
        { related_id: related_refugee_2.id }
      }

      it "updates the requested relationship" do
        relationship = Relationship.create! valid_attributes
        put :update, {refugee_id: refugee.id, :id => relationship.to_param, :relationship => new_attributes}, valid_session
        relationship.reload
        expect(relationship.related_id).to eq(new_attributes[:related_id])
      end

      it "assigns the requested relationship as @relationship" do
        relationship = Relationship.create! valid_attributes
        put :update, {refugee_id: refugee.id, :id => relationship.to_param, :relationship => valid_attributes}, valid_session
        expect(assigns(:relationship)).to eq(relationship)
      end

      it "redirects to show refugee" do
        relationship = Relationship.create! valid_attributes
        put :update, { refugee_id: refugee.id, :id => relationship.to_param, :relationship => valid_attributes}, valid_session
        expect(response).to redirect_to(refugee_path(refugee))
      end
    end

    context "with invalid params" do
      it "assigns the relationship as @relationship" do
        relationship = Relationship.create! valid_attributes
        put :update, {refugee_id: refugee.id, :id => relationship.to_param, :relationship => invalid_attributes}, valid_session
        expect(assigns(:relationship)).to eq(relationship)
      end

      it "re-renders the 'edit' template" do
        relationship = Relationship.create! valid_attributes
        put :update, {refugee_id: refugee.id, :id => relationship.to_param, :relationship => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested relationship" do
      relationship = Relationship.create! valid_attributes
      expect {
        delete :destroy, {refugee_id: refugee.id, :id => relationship.to_param}, valid_session
      }.to change(Relationship, :count).by(-1)
    end

    it "redirects to the show refugee" do
      relationship = Relationship.create! valid_attributes
      delete :destroy, {refugee_id: refugee.id, :id => relationship.to_param}, valid_session
      expect(response).to redirect_to(refugee_relationships_url(refugee))
    end
  end
end
