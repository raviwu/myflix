require 'spec_helper'
require "stripe"

describe StripeWrapper::Charge, :vcr do
  let(:token) { Stripe::Token.create(
    :card => {
      :number => card_number,
      :exp_month => 10,
      :exp_year => 2022,
      :cvc => "314"
    }
  ).id}

  context "with valid card" do
    let(:card_number) { '4242424242424242' }
    let(:response) { StripeWrapper::Charge.create(amount: 300, source: token) }

    it "charges the card successfully" do
      expect(response).to be_successful
    end
  end

  context "with invalid card" do
    let(:card_number) { '4000000000000002' }
    let(:response) { StripeWrapper::Charge.create(amount: 300, source: token) }

    it "does not charge the card" do
      expect(response).not_to be_successful
    end

    it "contains error message" do
      expect(response.error_message).to be_present
    end
  end
end
