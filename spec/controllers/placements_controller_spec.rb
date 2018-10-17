RSpec.describe PlacementsController, type: :controller do
    let(:valid_refugee) {
      Refugee.create!(name: "Valid refugee")
    }

    let(:valid_home) {
      Home.create!(name: "Valid home")
    }

    let(:legal_code) {
      LegalCode.create!(name: "Valid legal code")
    }

    let(:valid_attributes) {
      {
        home_id: valid_home.id,
        legal_code_id: legal_code.id,
        refugee_id: valid_refugee.id,
        moved_in_at: "2016-01-01"
      }
    }

    let(:invalid_attributes) {
      {
        home_id: valid_home.id + 1,
        legal_code_id: legal_code.id + 1,
        refugee_id: valid_refugee.id + 1,
        moved_in_at: "2016-01-01"
      }
    }

    describe "GET #new" do
      it "assigns a new placement as @placement" do
        get :new, params: { refugee_id: valid_refugee.id }, session: valid_session
        expect(assigns(:placement)).to be_a_new(Placement)
      end
    end

    describe "GET #edit" do
      it "assigns the requested placement as @placement" do
        placement = Placement.create! valid_attributes
        get :edit, params: { refugee_id: valid_refugee.id, :id => placement.to_param }, session: valid_session
        expect(assigns(:placement)).to eq(placement)
      end
    end

    describe "GET #move_out" do
      it "assigns the requested placement as @placement" do
        placement = Placement.create! valid_attributes
        get :move_out, params: { refugee_id: valid_refugee.id, :placement_id => placement.to_param }, session: valid_session
        expect(assigns(:placement)).to eq(placement)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Placement" do
          expect {
            post :create, params: { refugee_id: valid_refugee.id, :placement => valid_attributes}, session: valid_session
          }.to change(Placement, :count).by(1)
        end

        it "assigns a newly created placement as @placement" do
          post :create, params: { refugee_id: valid_refugee.id, :placement => valid_attributes}, session: valid_session
          expect(assigns(:placement)).to be_a(Placement)
          expect(assigns(:placement)).to be_persisted
        end

        it "redirects to the show refugee" do
          post :create, params: { refugee_id: valid_refugee.id, :placement => valid_attributes}, session: valid_session
          expect(response).to redirect_to(refugee_path(valid_refugee))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved placement as @placement" do
          post :create, params: { refugee_id: valid_refugee.id, :placement => invalid_attributes}, session: valid_session
          expect(assigns(:placement)).to be_a_new(Placement)
        end

        it "re-renders the 'new' template" do
          post :create, params: { refugee_id: valid_refugee.id, :placement => invalid_attributes}, session: valid_session
          expect(response).to render_template("new")
        end
      end

      context "strong params" do
        let(:attributes_with_specification) {
          {
            home_id: valid_home.id,
            legal_code: legal_code.id,
            refugee_id: valid_refugee.id,
            moved_in_at: "2016-01-01",
            specification: 'foo'
          }
        }

        it "save placement.specification when allowed " do
          valid_home.update_attribute(:use_placement_specification, true)
          post :create, params: { refugee_id: valid_refugee.id, :placement => attributes_with_specification}, session: valid_session
          expect(assigns(:placement).specification).to eq 'foo'
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { moved_in_at: '2016-01-02' }
        }

        let(:moved_out_attributes) {
          { moved_out_at: '2016-01-03' }
        }

        it "updates the requested placement" do
          placement = Placement.create! valid_attributes
          put :update, params: { refugee_id: valid_refugee.id, :id => placement.to_param, :placement => new_attributes}, session: valid_session
          placement.reload
          expect(placement.moved_in_at.to_s).to eq(new_attributes[:moved_in_at])
        end

        it "assigns the requested placement as @placement" do
          placement = Placement.create! valid_attributes
          put :update, params: { refugee_id: valid_refugee.id, :id => placement.to_param, :placement => valid_attributes}, session: valid_session
          expect(assigns(:placement)).to eq(placement)
        end

        it "redirects to show refugee" do
          placement = Placement.create! valid_attributes
          put :update, params: { refugee_id: valid_refugee.id, :id => placement.to_param, :placement => valid_attributes}, session: valid_session
          expect(response).to redirect_to(refugee_path(valid_refugee))
        end

        it "change the status to moved out" do
          placement = Placement.create! valid_attributes
          put :move_out_update, params: { refugee_id: valid_refugee.id, placement_id: placement.to_param, :placement => moved_out_attributes}, session: valid_session
          expect(placement.moved_out_at).to eq(valid_refugee[:moved_out_at])
          expect(valid_refugee.current_placements.size).to eq(0)
        end
      end

      context "with invalid params" do
        it "assigns the placement as @placement" do
          placement = Placement.create! valid_attributes
          put :update, params: { refugee_id: valid_refugee.id, :id => placement.to_param, :placement => invalid_attributes}, session: valid_session
          expect(assigns(:placement)).to eq(placement)
        end

        it "re-renders the 'edit' template" do
          placement = Placement.create! valid_attributes
          put :update, params: { refugee_id: valid_refugee.id, :id => placement.to_param, :placement => invalid_attributes}, session: valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    # describe "DELETE #destroy" do
    #   it "destroys the requested placement" do
    #     placement = Placement.create! valid_attributes
    #     expect {
    #       delete :destroy, params: { refugee_id: valid_refugee.id, :id => placement.to_param }, session: valid_session
    #     }.to change(Placement, :count).by(-1)
    #   end
    #
    #   it "redirects to the show refugee" do
    #     placement = Placement.create! valid_attributes
    #     delete :destroy, params: { refugee_id: valid_refugee.id, :id => placement.to_param }, session: valid_session
    #     expect(response).to redirect_to(placements_url)
    #   end
    # end
  end
