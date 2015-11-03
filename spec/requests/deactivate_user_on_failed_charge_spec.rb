require 'spec_helper'

describe 'Deactivate user on failed charge', :vcr do
  let(:event_data) {{
    "id" => "evt_173DJnGeF17FCPJ22TD95u65",
    "object" => "event",
    "api_version" => "2015-10-16",
    "created" => 1446589915,
    "data" => {
      "object" => {
        "id" => "ch_173DJnGeF17FCPJ2FbJERKr6",
        "object" => "charge",
        "amount" => 999,
        "amount_refunded" => 0,
        "application_fee" => nil,
        "balance_transaction" => nil,
        "captured" => false,
        "created" => 1446589915,
        "currency" => "usd",
        "customer" => "cus_7HXoZuaPzKHmr5",
        "description" => "myflix fee",
        "destination" => nil,
        "dispute" => nil,
        "failure_code" => "card_declined",
        "failure_message" => "Your card was declined.",
        "fraud_details" => {
        },
        "invoice" => nil,
        "livemode" => false,
        "metadata" => {
        },
        "paid" => false,
        "receipt_email" => nil,
        "receipt_number" => nil,
        "refunded" => false,
        "refunds" => {
          "object" => "list",
          "data" => [

          ],
          "has_more" => false,
          "total_count" => 0,
          "url" => "/v1/charges/ch_173DJnGeF17FCPJ2FbJERKr6/refunds"
        },
        "shipping" => nil,
        "source" => {
          "id" => "card_173DIVGeF17FCPJ2SOWJWo4L",
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
          "customer" => "cus_7HXoZuaPzKHmr5",
          "cvc_check" => "pass",
          "dynamic_last4" => nil,
          "exp_month" => 11,
          "exp_year" => 2018,
          "fingerprint" => "9QP9XAJ5MWWfwam4",
          "funding" => "credit",
          "last4" => "0341",
          "metadata" => {
          },
          "name" => nil,
          "tokenization_method" => nil
        },
        "statement_descriptor" => "MyFLix fee",
        "status" => "failed"
      }
    },
    "livemode" => false,
    "pending_webhooks" => 0,
    "request" => "req_7Hmt5V8XdQarkd",
    "type" => "charge.failed"
  }}

  before do
    Fabricate(:user, customer_token: "cus_7HXoZuaPzKHmr5")
    post '/stripe_events', event_data
  end

  it "deactivates user with webhook stripe data for charge failed" do
    expect(User.last).not_to be_active
  end
end
