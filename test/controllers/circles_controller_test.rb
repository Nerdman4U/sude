# coding: utf-8
require 'test_helper'

class CirclesControllerTest < ActionDispatch::IntegrationTest

  test 'should get show' do
    circle = create(:circle)
    get circle_path(circle)
    assert_response :success
  end

  test 'should create circle' do
    assert_difference 'Circle.count' do
      post circles_path, params: { circle: { name: "Asiaan X1 liittyvät ehdotukset" }}
    end
    assert_redirected_to circle_path(Circle.last)
  end

  test 'should get index' do
    get circles_path
    assert_response :success
  end
end
