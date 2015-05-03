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

  post '/charge' do
    Stripe::Charge.create(
      :amount => 400,
      :currency => "usd",
      :source => params[:stripeToken], # obtained with Stripe.js
      :metadata => {'email' => params[:stripeEmail]},
      :description => "Charge for test@example.com"
    )

    redirect '/success'
  end
end