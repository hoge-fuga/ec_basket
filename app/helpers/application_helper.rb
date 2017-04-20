module ApplicationHelper
  def jpy_comma(num)
    return num.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end
end
