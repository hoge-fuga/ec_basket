module ParseHtmlHelper
  require 'uri'
  require 'open-uri'
  require 'kconv'
  require 'nokogiri'
    
  def parse_html(url)
    #　urlから商品情報のパース
    if url.blank?
      return 1
    end
    parsed_params = _parse_html(url)
    if !parsed_params
      return 2
    end
    return _parse_html(url)
  end  
    
  def _parse_html(url)
    html = get_html(url)
    if html
      doc = Nokogiri::HTML(html.toutf8, nil, 'utf-8')
    else
        return false
    end
    return get_params(url, doc)
  end
  
  def get_html(url)
    10.times do |i|
      begin
        html = open(url, "r:binary", 'User-Agent' => 'EC Backet').read
        return html
      rescue OpenURI::HTTPError
        sleep(1)
        next
      end
    end
    return false
  end
  
  def get_params(url, doc)
    uri = URI.parse(url)
    host = uri.host
    case host
    when /amazon\.co\.jp/
      return get_from_amazon(url,doc)
    when /rakuten\.co\.jp/
      return get_from_rakuten(url,doc)
    else
      return get_from_other(url,doc)
    end
    
    return false
  end
  
  def get_from_amazon(url,doc)
    # amazon
    name_obj = doc.at_xpath('//*[@id="productTitle"]')
    
    ourprice_obj = doc.at_xpath('//*[@id="priceblock_ourprice"]')
    if ourprice_obj.nil?
      dealprice_obj = doc.at_xpath('//*[@id="priceblock_dealprice"]')
      price_obj = dealprice_obj
    else
      price_obj = ourprice_obj
    end
    
    image_obj = doc.at_xpath('//*[@id="landingImage"]')
   
    return { name: get_name(doc, name_obj), price: get_price(doc, price_obj), image_url: get_image_url(url, doc, image_obj)}
  end
  
  def get_from_rakuten(url,doc)
    # rakuten
    name_obj = doc.at_css('#pagebody span.item_name')
    
    price_obj = doc.at_css('#pagebody span.price2')

    image_obj = doc.at_css('#pagebody a.rakutenLimitedId_ImageMain1-3 img')
   
    return { name: get_name(doc, name_obj), price: get_price(doc, price_obj), image_url: get_image_url(url, doc, image_obj)}
  end
  
  def get_from_other(url,doc)
    name_obj = doc.at_xpath('//head/title')
    price_obj = doc.at_xpath('//*[not(contains(@id,"price")) and not(contains(@class,"price"))]//*[contains(@id,"price") or  contains(@class,"price")]//*[( contains( ./text() ,"¥") or contains( ./text() ,"￥") or contains(./text(),"円") ) and ( string-length(normalize-space()) > 4) ]')
    return { name: get_name(doc, name_obj), price: get_price(doc,price_obj), image_url: get_image_url(url,doc,nil)}
  end
  
  def get_name(doc, obj)
    if obj.nil?
      obj = doc.at_xpath('//head/title')
      if obj.nil?
        return "unkown"
      end
    end
    
    str = obj.text
    name = str.strip[0,250]
    return name
  end
 
  def get_price(doc, obj)
    if obj.nil?
      obj = doc.at_xpath('//*[not(contains(@id,"price")) and not(contains(@class,"price") and not(contains(@id,"Price") and not(contains(@class,"Price"))]//*[contains(@id,"price") or  contains(@class,"price") or  contains(@id,"Price") or  contains(@class,"Price")]//*[( contains( ./text() ,"¥") or contains( ./text() ,"￥") or contains(./text(),"円") ) and ( string-length(normalize-space()) > 4 )]')
      if obj.nil?
        return nil
      end
    end
    str = obj.text
    price = full_to_half(str.strip).gsub(/\D/,"").to_i
    return price
  end
  
  def get_image_url(url,doc, obj)
    if obj.nil?
      img_path = "/favicon.ico"
    else
      img_path = obj.get_attribute('src').strip
    end
    img_url = URI.join(url, img_path).to_s
    return img_url
  end
  

  def full_to_half(str)
    str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

end
