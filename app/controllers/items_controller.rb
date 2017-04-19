class ItemsController < ApplicationController
  before_action :require_user_logged_in

  def new
    @item = Item.new
  end

  def create
    url = item_params[:url]
    if url.blank?
      # URL未入力のエラー通知
      flash[:danger] = '商品URLが未入力です。'
    else
      parsed_params = parse_html(url)
      if parsed_params
        item = Item.new(user: current_user, url: url, **parsed_params)
        if item.save
          flash[:success] = '商品を買い物リストに追加しました。'
        else
          flash[:danger] = 'データベースへの追加に失敗しました。'
        end
      else
        # パース失敗の通知
        flash[:danger] = '商品ページの取得に失敗しました。'
      end
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
  
  def parse_html(url)
    #　urlから商品情報のパース
    return { name: "hoge", price: 100, image_url: "https://images-na.ssl-images-amazon.com/images/I/81LY96goTLL._SY679_.jpg"}
  end
  
  def _parse_html(url)
    
    return { name: "hoge", price: 100, image_url: "https://images-na.ssl-images-amazon.com/images/I/81LY96goTLL._SY679_.jpg"}
  end
end