class ItemsController < ApplicationController
  before_action :require_user_logged_in
  include ParseHtmlHelper

  def new
    @item = Item.new
    @user = current_user
    api_url = api_item_create_url
    user_id_str = @user.id.to_s
    @bookmarklet = 'javascript:void ((function(b){var a=new XMLHttpRequest();a.open("POST","'+api_url+'",true);a.setRequestHeader("Content-Type","application/x-www-form-urlencoded");a.send("id='+user_id_str+'&url="+encodeURIComponent(location.href))})());'
  end
  
  def manual_new()
    @item = Item.new
  end
  
  def edit()
    @item = Item.find(params[:id])
  end
    
  def update()
    item = Item.find(params[:id])
    if item.update(manual_item_params)
      flash[:success] = '商品は正常に更新されました'
      redirect_to user_path(id: current_user.id)
    else
      flash.now[:danger] = '商品は更新されませんでした'
      render :edit
    end
  end

  def create
    if params[:manual_new]
      # マニュアル登録
      item = Item.new(user: current_user, url: manual_item_params[:url], name: manual_item_params[:name], price: manual_item_params[:price].to_i, image_url: manual_item_params[:image_url])
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
      flash[:danger] = 'データベースへの追加に失敗しました。' + item.errors.full_messages.to_s
    end
    session[:item_id] = item.id
    redirect_to current_user
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
    params.require(:item).permit(:url, :name, :price ,:image_url)
  end
  
end