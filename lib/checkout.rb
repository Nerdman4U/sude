# coding: utf-8
# https://checkoutfinland.github.io/#payment
class Checkout

  attr_accessor :user
  attr_accessor :merchant_id
  attr_accessor :secret_key
  attr_accessor :address
  attr_accessor :user
  attr_accessor :postcode
  attr_accessor :postoffice
  attr_accessor :phone
  attr_accessor :response_xml
  attr_accessor :banks
  
  def initialize options
    @user = options[:user]
    @merchant_id = "375917"
    @secret_key = "SAIPPUAKAUPPIAS"
    @address = "Kuusitie 7"
    @postcode = "42300"
    @postoffice = "Jämsänkoski"
    @phone = "0401517622"
    @response_xml = ""
    @banks = []
  end

  def success_callback
    Rails.application.routes.url_helpers.success_callback_url
  end
  def cancel_callback
    Rails.application.routes.url_helpers.cancel_callback_url
  end
  def reject_callback
    Rails.application.routes.url_helpers.reject_callback_url
  end
  def delayed_callback
    Rails.application.routes.url_helpers.delayed_callback_url
  end

  def firstname
    raise ValueError if user.fullname.blank?
    user.fullname.split(" ")[0]
  end
  def lastname
    raise ValueError if user.fullname.blank?
    user.fullname.split(" ")[-1]
  end
  
  def order_information
    @order_information ||= {
      "VERSION" => "0001",
      "STAMP" => Time.now.to_i,
      "AMOUNT" => "500",
      "REFERENCE" => "1234",
      "MESSAGE" => "Suomen Demokratia ry:n vuosittainen jäsenmaksu",
      "LANGUAGE" => "FI",
      "MERCHANT" => self.merchant_id,
      "RETURN" => success_callback,
      "CANCEL" => cancel_callback,
      "REJECT" => reject_callback,
      "DELAYED" => delayed_callback,
      "COUNTRY" => "FIN",
      "CURRENCY" => "EUR",
      "DEVICE" => 10,
      "CONTENT" => 1,
      "TYPE" => 0,
      "ALGORITHM" => 3,
      "DELIVERY_DATE" => Time.now.strftime("%Y%m%d"),
      "FIRSTNAME" => firstname,
      "FAMILYNAME" => lastname,
      "ADDRESS" => self.address,
      "POSTCODE" => self.postcode,
      "POSTOFFICE" => self.postoffice,
      "EMAIL" => user.email,
      "PHONE" => self.phone
    }
  end

  def checksum_items
    [:version, :stamp, :amount, :reference, :message, :language,
     :merchant, :return, :cancel, :reject, :delayed, :country, :currency,
     :device, :content, :type, :algorithm, :delivery_date, :firstname,
     :familyname, :address, :postcode, :postoffice].map do |item|
      value = order_information[item.to_s.upcase]
      value.blank? ? " " : value.to_s
    end << self.secret_key.to_s
  end
  
  def calculate_checksum
    require "digest/md5"
    Digest::MD5.hexdigest(checksum_items.join("+")).upcase
  end

  def parse_bank bank 
    require "rexml/document"
    data = {}
    data[:name] = bank.name
    data[:icon] = bank.attributes["icon"]
    data[:url] = bank.attributes["url"]
    data[:xml] = bank
    self.banks << data
  end

  def parse_response_xml
    require "rexml/document"
    doc = REXML::Document.new(response_xml)
    doc.elements.each("/trade/payments/payment/banks") do |e|
      e.elements.each do |bank|
        parse_bank bank
      end
    end
  end

  def open_test_xml
    open(Rails.root.join("lib/checkout_response.xml")).read
  end
  
  # POST: https://payment.checkout.fi
  def post_payment
    require 'net/http'
    order_information["MAC"] = calculate_checksum
    uri = URI('https://payment.checkout.fi')

    if Rails.env.test?
      self.response_xml = open_test_xml
    else
      res = Net::HTTP.post_form(uri, order_information)
      puts "Sending #{res} to checkout.fi..."
      self.response_xml = res.body
    end
    
  end
end
