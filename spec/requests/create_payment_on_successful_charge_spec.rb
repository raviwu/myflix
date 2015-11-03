require 'spec_helper'

describe 'Create payment on successful charge', :vcr do
  let(:event_data) {{
    "id" => "evt_172rS9GeF17FCPJ2TqL3lnvx",
    "object" => "event",
    "api_version" => "2015-10-16",
    "created" => 1446505865,
    "data" => {
      "object" => {
        "id" => "ch_172rS9GeF17FCPJ2xT8kGcEz",
        "object" => "charge",
        "amount" => 999,
        "amount_refunded" => 0,
        "application_fee" => nil,
        "balance_transaction" => "txn_172rS9GeF17FCPJ2l4KitQGM",
        "captured" => true,
        "created" => 1446505865,
        "currency" => "usd",
        "customer" => "cus_7HQIILg3mFplK1",
        "description" => nil,
        "destination" => nil,
        "dispute" => nil,
        "failure_code" => nil,
        "failure_message" => nil,
        "fraud_details" => {
        },
        "invoice" => "in_172rS9GeF17FCPJ28ucdsLby",
        "livemode" => false,
        "metadata" => {
        },
        "paid" => true,
        "receipt_email" => nil,
        "receipt_number" => nil,
        "refunded" => false,
        "refunds" => {
          "object" => "list",
          "data" => [

          ],
          "has_more" => false,
          "total_count" => 0,
          "url" => "/v1/charges/ch_172rS9GeF17FCPJ2xT8kGcEz/refunds"
        },
        "shipping" => nil,
        "source" => {
          "id" => "card_172rS7GeF17FCPJ2lL7nekoF",
          "object" => "card",
          "address_city" => nil,
          "address_country" => nil,
          "address_line1" => nil,
          "address_line1_check" => nil,
          "address_line2" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_zip_check" => nil,
          "brand" => "Visa",
          "country" => "US",
          "customer" => "cus_7HQIILg3mFplK1",
          "cvc_check" => "pass",
          "dynamic_last4" => nil,
          "exp_month" => 11,
          "exp_year" => 2015,
          "fingerprint" => "lBuC8qY1FR9nqFir",
          "funding" => "credit",
          "last4" => "4242",
          "metadata" => {
          },
          "name" => nil,
          "tokenization_method" => nil
        },
        "statement_descriptor" => "MyFLix Base Plan",
        "status" => "succeeded"
      }
    },
    "livemode" => false,
    "pending_webhooks" => 1,
    "request" => "req_7HQIvG9DKHNBB2",
    "type" => "charge.succeeded"
  }}

  before do
    Fabricate(:user, customer_token: "cus_7HQIILg3mFplK1")
    post '/stripe_events', event_data
  end

  it 'creates the payment with the webhook from stripe for charge succeeded' do
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user" do
    expect(Payment.last.user).to eq(User.last)
  end

  it "creates the payment with amount" do
    expect(Payment.last.amount).to eq(999)
  end

  it "creates the payment with reference_id" do
    expect(Payment.last.reference_id).to eq("ch_172rS9GeF17FCPJ2xT8kGcEz")
  end
end
