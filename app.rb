require 'sinatra'
require './text_finder.rb'


get '/' do
  erb :index
end

post '/count' do
  urls = params[:urls].split("\r\n")
  finder = MultipleTextFinder.new(*urls)
  @counts = finder.counts
  pp @counts

  erb :results
end
