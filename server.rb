require 'sinatra'
require 'stripe'

Stripe.api_key = ENV["STRIPE_API_KEY"]

class Cashin < Sinatra::Base
  get '/' do
    erb :pay
  end

  get '/success' do
    erb :success
  end

  get '/styles.css' do
    scss :styles, :style => :compressed
  end

  post '/charge' do
    charge = Stripe::Charge.create(
      :amount => 400,
      :currency => "usd",
      :source => params[:stripeToken],
      :metadata => {'email' => params[:stripeEmail]},
      :description => "Charge for test@example.com"
    )

    redirect '/success'
  end
end