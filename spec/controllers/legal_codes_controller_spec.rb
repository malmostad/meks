require 'rails_helper'

RSpec.describe LegalCodesController, type: :controller do
  let(:valid_attributes) {
    { name: 'SoL' }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  describe "GET #index" do
    it "assigns all legal_codes as @legal_codes" do
      legal_code = LegalCode.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:legal_codes)).to eq([legal_code])
    end
  end

  describe "GET #new" do
    it "assigns a new legal_code as @legal_code" do
      get :new, {}, valid_session
      expect(assigns(:legal_code)).to be_a_new(LegalCode)
    end
  end

  describe "GET #edit" do
    it "assigns the requested legal_code as @legal_code" do
      legal_code = LegalCode.create! valid_attributes
      get :edit, {:id => legal_code.to_param}, valid_session
      expect(assigns(:legal_code)).to eq(legal_code)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new LegalCode" do
        expect {
          post :create, {:legal_code => valid_attributes}, valid_session
        }.to change(LegalCode, :count).by(1)
      end

      it "assigns a newly created legal_code as @legal_code" do
        post :create, {:legal_code => valid_attributes}, valid_session
        expect(assigns(:legal_code)).to be_a(LegalCode)
        expect(assigns(:legal_code)).to be_persisted
      end

      it "redirects to the created legal_code" do
        post :create, {:legal_code => valid_attributes}, valid_session
        expect(response).to redirect_to(legal_codes_url)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved legal_code as @legal_code" do
        post :create, {:legal_code => invalid_attributes}, valid_session
        expect(assigns(:legal_code)).to be_a_new(LegalCode)
      end

      it "re-renders the 'new' template" do
        post :create, {:legal_code => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end

      it "too long name" do
        post :create, {:legal_code => { name: 'x' * 200 }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested legal_code" do
        legal_code = LegalCode.create! valid_attributes
        new_name = "#{legal_code.name} updated"
        put :update, {:id => legal_code.to_param, :legal_code => { name: new_name } }, valid_session
        legal_code.reload
        expect(legal_code.name).to eq(new_name)
      end

      it "assigns the requested legal_code as @legal_code" do
        legal_code = LegalCode.create! valid_attributes
        put :update, {:id => legal_code.to_param, :legal_code => valid_attributes}, valid_session
        expect(assigns(:legal_code)).to eq(legal_code)
      end

      it "redirects to the legal_code" do
        legal_code = LegalCode.create! valid_attributes
        put :update, {:id => legal_code.to_param, :legal_code => valid_attributes}, valid_session
        expect(response).to redirect_to(legal_codes_url)
      end
    end

    context "with invalid params" do
      it "assigns the legal_code as @legal_code" do
        legal_code = LegalCode.create! valid_attributes
        put :update, {:id => legal_code.to_param, :legal_code => invalid_attributes}, valid_session
        expect(assigns(:legal_code)).to eq(legal_code)
      end

      it "re-renders the 'edit' template" do
        legal_code = LegalCode.create! valid_attributes
        put :update, {:id => legal_code.to_param, :legal_code => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested legal_code" do
      legal_code = LegalCode.create! valid_attributes
      expect {
        delete :destroy, {:id => legal_code.to_param}, valid_session
      }.to change(LegalCode, :count).by(-1)
    end

    it "redirects to the legal_codes list" do
      legal_code = LegalCode.create! valid_attributes
      delete :destroy, {:id => legal_code.to_param}, valid_session
      expect(response).to redirect_to(legal_codes_url)
    end
  end
end
