module StripeWrapper

  class Charge
    attr_reader :response, :status

    def initialize(options = {})
      @response = options[:response]
      @status = options[:status]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          source: options[:source],
          description: options[:description]
        )
        new(response: response, status: :success)
      rescue Stripe::CardError => e
        new(response: e, status: :danger)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer
    attr_reader :response, :status

    def initialize(options = {})
      @response = options[:response]
      @status = options[:status]
    end

    def self.create(options = {})
      begin
        response = Stripe::Customer.create(
          :source => options[:source],
          :plan => "myflix_base",
          :email => options[:user].email
        )
        new(response: response, status: :success)
      rescue Stripe::CardError => e
        new(response: e, status: :danger)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end

    def customer_token
      response.id
    end
  end

end
