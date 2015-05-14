require 'sinatra'
require 'stripe'
require 'digest'

Stripe.api_key = ENV["STRIPE_API_SECRET_KEY"]

class Cashin < Sinatra::Base
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  get '/' do
    md5 = Digest::MD5.new.update(ENV['USER_EMAIL'])
    erb :pay, locals: {admin_hash: md5.hexdigest}
  end

  get '/styles.css' do
    scss :styles, :style => :compressed
  end

  post '/charge' do
    charge = Stripe::Charge.create(
      :amount => params[:amount],
      :currency => "usd",
      :source => params[:stripeToken],
      :metadata => {
        'email' => params[:stripeEmail],
        'reason' => params[:reason]
      },
      :description => "Cashin Charge"
    )
    'success'
  end
end