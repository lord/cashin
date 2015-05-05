require 'sinatra'
require 'stripe'
require 'digest'

Stripe.api_key = ENV["STRIPE_API_KEY"]

class Cashin < Sinatra::Base
  get '/' do
    md5 = Digest::MD5.new.update(ENV['USER_EMAIL'])
    erb :pay, locals: {admin_hash: md5.hexdigest}
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
  end
end