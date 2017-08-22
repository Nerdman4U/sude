# coding: utf-8
require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest

  test 'should route root' do
    assert_generates "/fi", controller: "vote_proposals", action: "index", locale: "fi"
  end

  test 'should route vote_proposals' do
    assert_recognizes({controller: "vote_proposals", action: "index", locale: "fi"}, "/fi/#{CGI.escape('äänestysehdotukset')}")
  end
  
  test 'should route vote_proposals with group_id' do
    assert_generates "/fi/#{CGI.escape('äänestysehdotukset')}/1", controller: :vote_proposals, action: :index, group_id: 1, locale: "fi"
  end

end
