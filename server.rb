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
      :source => params[:stripeToken], # obtained with Stripe.js
      :metadata => {'email' => params[:stripeEmail]},
      :description => "Charge for test@example.com",
      :capture => false
    )

    if charge.source.funding == "debit"
      redirect '/?error=debit'
      return
    end

    charge.capture

    redirect '/success'
  end
end