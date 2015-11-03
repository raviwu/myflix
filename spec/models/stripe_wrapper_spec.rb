require 'spec_helper'
require "stripe"

describe StripeWrapper do
  let(:valid_token) { Stripe::Token.create(
    :card => {
      :number => '4242424242424242',
      :exp_month => 10,
      :exp_year => 2022,
      :cvc => "314"
    }
  ).id}
  let(:declined_token) { Stripe::Token.create(
    :card => {
      :number => '4000000000000002',
      :exp_month => 10,
      :exp_year => 2022,
      :cvc => "314"
    }
  ).id}

  describe StripeWrapper::Charge, :vcr do

    context "with valid card" do
      it "charges the card successfully" do
        response = StripeWrapper::Charge.create(amount: 300, source: valid_token)
        expect(response).to be_successful
      end
    end

    context "with invalid card" do
      let(:response) { StripeWrapper::Charge.create(amount: 300, source: declined_token) }

      it "does not charge the card" do
        expect(response).not_to be_successful
      end

      it "contains error message" do
        expect(response.error_message).to be_present
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do
      context "with valid card" do
        let(:response) {StripeWrapper::Customer.create(user: Fabricate(:user), source: valid_token)}

        it "creates a stripe customer" do
          expect(response).to be_successful
        end

        it "returns a customer token" do
          expect(response.customer_token).to be_present
        end
      end

      context "with invalid card" do
        let(:response) { StripeWrapper::Customer.create(user: Fabricate(:user), source: declined_token) }

        it "does not charge the card" do
          expect(response).not_to be_successful
        end

        it "contains error message" do
          expect(response.error_message).to be_present
        end
      end
    end
  end
end
