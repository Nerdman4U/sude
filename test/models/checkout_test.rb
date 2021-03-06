require 'test_helper'
require Rails.root.join("lib/checkout.rb")

class CheckoutTest < ActiveSupport::TestCase

  test 'should parse xml' do
    check = Checkout.new({user: create(:user)})
    check.post_payment
    assert check.parse_response_xml
    assert check.banks.count > 0
  end

  test 'should initialize' do
    check = Checkout.new({user: create(:user)})
    assert check
  end

  test 'should return callback paths' do
    check = Checkout.new({user: create(:user)})
    assert check.success_callback
    assert check.cancel_callback
    assert check.reject_callback
    assert check.delayed_callback
  end

  test 'should raise error if fullname is empty' do
    user = create(:user)
    user.fullname = nil
    check = Checkout.new({user: user})
    assert_raise do
      check.firstname
    end
  end

  test 'should return order information' do
    check = Checkout.new({user: create(:user)})
    info = check.order_information
    assert_equal info["VERSION"], "0001"
  end

  test 'should return checksum items' do
    check = Checkout.new({user: create(:user)})
    assert_equal check.checksum_items.size, 24
    assert_equal check.checksum_items[2], "500"
  end

  test 'should calculate md5' do
    check = Checkout.new({user: create(:user)})
    assert check.calculate_checksum    
  end

  test 'should post payment' do
    check = Checkout.new({user: create(:user)})
    check.post_payment
    
  end
  
end
