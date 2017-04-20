module ParseHtmlHelper
  require 'uri'
  require 'open-uri'
  require 'kconv'
  require 'nokogiri'
    
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
        html = open(url, "r:binary", options = {'User-Agent' => 'EC Backet'}).read
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
      return get_from_amazon(doc)
    when /rakuten\.co\.jp/
      return get_from_rakuten(doc)
    end
    
    return false
  end
  
  def get_from_amazon(doc)
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
   
    return { name: get_name(name_obj), price: get_price(price_obj), image_url: get_image_url(image_obj)}
  end
  
  def get_from_rakuten(doc)
    # rakuten
    name_obj = doc.at_css('#pagebody span.item_name')
    
    price_obj = doc.at_css('#pagebody span.price2')

    image_obj = doc.at_css('#pagebody a.rakutenLimitedId_ImageMain1-3 img')
   
    return { name: get_name(name_obj), price: get_price(price_obj), image_url: get_image_url(image_obj)}
  end
  
  def get_name(obj)
    if obj.nil?
      return "unknown"
    end
    str = obj.text
    return str.strip[0,250]
  end
 
  def get_price(obj)
    if obj.nil?
      return nil
    end
    str = obj.text
    return full_to_half(str.strip).gsub(/\D/,"").to_i
  end
  
  def get_image_url(obj)
    if obj.nil?
      return nil
    end
    return obj.get_attribute('src').strip
  end
  

  def full_to_half(str)
    str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

end
