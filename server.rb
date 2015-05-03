require 'sinatra'
require 'stripe'

class Cashin < Sinatra::Base
  get '/' do
    'test'
  end
end