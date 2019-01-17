RSpec.describe TypeOfHousingsController, type: :controller do
  # Ability is currently disabled for everyone

  # let(:valid_attributes) {
  #   { name: "Type of housing" }
  # }
  #
  # let(:invalid_attributes) {
  #   { name: "" }
  # }
  #
  # describe "GET #index" do
  #   it "assigns all type_of_housings as @type_of_housings" do
  #     type_of_housing = TypeOfHousing.create! valid_attributes
  #     get :index, params: {}, session: valid_session
  #     expect(assigns(:type_of_housings)).to eq([type_of_housing])
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new type_of_housing as @type_of_housing" do
  #     get :new, params: {}, session: valid_session
  #     expect(assigns(:type_of_housing)).to be_a_new(TypeOfHousing)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested type_of_housing as @type_of_housing" do
  #     type_of_housing = TypeOfHousing.create! valid_attributes
  #     get :edit, params: { id: type_of_housing.to_param }, session: valid_session
  #     expect(assigns(:type_of_housing)).to eq(type_of_housing)
  #   end
  # end
  #
  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new TypeOfHousing" do
  #       expect {
  #         post :create, params: { type_of_housing: valid_attributes }, session: valid_session
  #       }.to change(TypeOfHousing, :count).by(1)
  #     end
  #
  #     it "assigns a newly created type_of_housing as @type_of_housing" do
  #       post :create, params: { type_of_housing: valid_attributes }, session: valid_session
  #       expect(assigns(:type_of_housing)).to be_a(TypeOfHousing)
  #       expect(assigns(:type_of_housing)).to be_persisted
  #     end
  #
  #     it "redirects to the type_of_housings index" do
  #       post :create, params: { type_of_housing: valid_attributes }, session: valid_session
  #       expect(response).to redirect_to(TypeOfHousing)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved type_of_housing as @type_of_housing" do
  #       post :create, params: { type_of_housing: invalid_attributes }, session: valid_session
  #       expect(assigns(:type_of_housing)).to be_a_new(TypeOfHousing)
  #     end
  #
  #     it "re-renders the 'new' template" do
  #       post :create, params: { type_of_housing: invalid_attributes }, session: valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end
  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       { name: "Name updated" }
  #     }
  #
  #     it "updates the requested type_of_housing" do
  #       type_of_housing = TypeOfHousing.create! valid_attributes
  #       put :update, params: { id: type_of_housing.to_param, type_of_housing: new_attributes}, session: valid_session
  #       type_of_housing.reload
  #       expect(type_of_housing.name).to eq(new_attributes[:name])
  #     end
  #
  #     it "assigns the requested type_of_housing as @type_of_housing" do
  #       type_of_housing = TypeOfHousing.create! valid_attributes
  #       put :update, params: { id: type_of_housing.to_param, type_of_housing: valid_attributes}, session: valid_session
  #       expect(assigns(:type_of_housing)).to eq(type_of_housing)
  #     end
  #
  #     it "redirects to the type_of_housing" do
  #       type_of_housing = TypeOfHousing.create! valid_attributes
  #       put :update, params: { id: type_of_housing.to_param, type_of_housing: valid_attributes}, session: valid_session
  #       expect(response).to redirect_to(TypeOfHousing)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns the type_of_housing as @type_of_housing" do
  #       type_of_housing = TypeOfHousing.create! valid_attributes
  #       put :update, params: { id: type_of_housing.to_param, type_of_housing: invalid_attributes}, session: valid_session
  #       expect(assigns(:type_of_housing)).to eq(type_of_housing)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       type_of_housing = TypeOfHousing.create! valid_attributes
  #       put :update, params: { id: type_of_housing.to_param, type_of_housing: invalid_attributes}, session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested type_of_housing" do
  #     type_of_housing = TypeOfHousing.create! valid_attributes
  #     expect {
  #       delete :destroy, params: { id: type_of_housing.to_param }, session: valid_session
  #     }.to change(TypeOfHousing, :count).by(-1)
  #   end
  #
  #   it "redirects to the type_of_housings list" do
  #     type_of_housing = TypeOfHousing.create! valid_attributes
  #     delete :destroy, params: { id: type_of_housing.to_param }, session: valid_session
  #     expect(response).to redirect_to(type_of_housings_url)
  #   end
  # end
end
