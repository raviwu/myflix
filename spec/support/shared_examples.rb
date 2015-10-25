shared_examples "require_sign_in" do
  it "redirects to the sign_in_path" do
    clear_current_user
    action
    response.should redirect_to(sign_in_path)
  end
end

shared_examples "require_admin" do
  before do
    set_current_user
    action
  end
  it "redircts regular user to root_path" do
    expect(response).to redirect_to(root_path)
  end
  it "sets flash[:danger]" do
    expect(flash[:danger]).to be_present
  end
end

shared_examples "tokenable" do
  it "generate a random token when the user is created" do
    expect(object.token).to be_present
  end
end
