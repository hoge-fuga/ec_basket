class ItemsController < ApplicationController
  before_action :require_user_logged_in
  include ParseHtmlHelper

  def new
    @item = Item.new
    @user = current_user
  end

  def create
    if params[:manual_new]
      # マニュアル登録
      item = Item.new(user: current_user, url: params[:url], name: params[:name], price: params[:price].to_i, image_url: params[:image_url])
    else
      # URLから自動登録
      url = item_params[:url]

      parsed_params = parse_html(url)
      case parsed_params
      when 1
        # URL未入力のエラー通知
        flash[:danger] = '商品URLが未入力です。'
        redirect_back(fallback_location: root_path)
        return
      when 2
        # パース失敗の通知
        flash[:danger] = '商品ページの取得に失敗しました。'
        redirect_back(fallback_location: root_path)
        return
      end
      item = Item.new(user: current_user, url: url, **parsed_params)
    end
  
    if item.save
      flash[:success] = '商品を買い物リストに追加しました。'
    else
      flash[:danger] = 'データベースへの追加に失敗しました。'
    end
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    item = Item.find(params[:id])
    
    if item.destroy 
      flash[:success] = '商品を買い物リストから除外しました。'
    end

    redirect_back(fallback_location: root_path)
  end

  private
  
  def item_params
    params.require(:item).permit(:url)
  end
    
  def manual_item_params
    params.require(:item).permit(:url)
  end
  
end