shared_examples "require_sign_in" do
  it "redirects to the sign_in_path" do
    clear_current_user
    action
    response.should redirect_to(sign_in_path)
  end
end

shared_examples "tokenable" do
  it "generate a random token when the user is created" do
    expect(object.token).to be_present
  end
end
