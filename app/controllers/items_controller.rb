class ItemsController < ApplicationController
  before_action :require_user_logged_in
  include ParseHtmlHelper

  def new
    @item = Item.new
  end

  def create
    if params[:manual_new]
      # マニュアル登録
      #item = Item.new(user: current_user, url: params[:url], name: params[:name], price: params[:price].to_i, image_url: params[:image_url])
      item = Item.new(user: current_user, url: params[:url], name: "a", price: 1, image_url: "https://www.amazon.co.jp/gp/product/B00YNANGOK/ref=s9_acsd_hps_bw_c_x_1_w?pf_rd_m=AN1VRQENFRJN5&pf_rd_s=merchandised-search-10&pf_rd_r=GDEWFDZQT3CZGBQWXD5C&pf_rd_r=GDEWFDZQT3CZGBQWXD5C&pf_rd_t=101&pf_rd_p=19f4a0a4-28a0-4e7e-90ab-0c475041c661&pf_rd_p=19f4a0a4-28a0-4e7e-90ab-0c475041c661&pf_rd_i=57239051")
    else
      # URLから自動登録
      url = item_params[:url]
      if url.blank?
        # URL未入力のエラー通知
        flash[:danger] = '商品URLが未入力です。'
        redirect_back(fallback_location: root_path)
        return
      end
      
      parsed_params = parse_html(url)
      if !parsed_params
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
  
  def parse_html(url)
    #　urlから商品情報のパース
    return _parse_html(url)
  end
  
end