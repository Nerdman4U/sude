# coding: utf-8
require Rails.root.join("lib/checkout.rb")

class DemocracyController < ApplicationController
  def instruction
  end

  # Current user can confirm his/her account by paying yhdistyksen
  # vuosimaksun. 
  def confirm
    # Cannot do with guest account
    return unless current_user    
    do_checkout
  end

  def do_checkout
    @check ||= begin
                 check = Checkout.new(user: current_user)
                 check.post_payment
                 check.parse_response_xml
                 check
               end
  end

  
  # 1 	Payment version. Always “0001”. 	VERSION 	“0001”
  # 2 	Unique identifier for the payment in the context of the merchant. Has to be unique. 	STAMP 	unique_id
  # 3 	Payment reference number for the payment from the merchant. 	REFERENCE 	standard_reference
  # 4 	Payment archive id 	PAYMENT 	Checkouts unique ID for the payment.
  # 5 	Payment status 	STATUS 	2 = success
  # 6  	 Used algorithm. Use 3. 	ALGORTH 	 3
  # 7 	MAC check 	MAC
  def checkout_success
    status = params["STATUS"]
    if status == "2"
      current_user.confirmed = true
      current_user.save
      flash[:notice] =
        "Tervetuloa Suomen Demokratia ry:n jäseneksi! Käyttäjätilisi on vahvistettu."
    else
      flash[:alert] = "Maksu epäonnistui"
    end
    redirect_to root_path
  end
  def checkout_cancel
    flash[:notice] = "Keskeytit tapahtuman. Koodaus on myös kesken."
    redirect_to root_path
  end
  def checkout_reject
    flash[:notice] = "Hylkäsit tapahtuman. Koodaus on kesken."
    redirect_to root_path
  end
  def checkout_delayed
    flash[:notice] = "Tapahtuman käsittelyssä on viive. Koodaus on kesken."
    redirect_to root_path
  end
  
end
