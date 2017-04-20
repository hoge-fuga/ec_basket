class ApiController < ApplicationController
  protect_from_forgery :except => [:item_create]
  
  include ParseHtmlHelper
  
  def item_create
    user = User.find(params[:id].to_i)
    url = params[:url]
    parsed_params = parse_html(url)
    item = Item.new(user: user, url: url, **parsed_params)
    if item.save
      render json: {status: "OK"}
    else
      render json: {status:"Error"}
    end
  end
end