# coding: utf-8
require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest

  test 'should route circles' do
    assert_generates "/fi/circles", controller: "circles", action: "index", locale: "fi"
    assert_recognizes({controller: "circles", action: "create", locale: "fi"},{path: "/fi/circles", method: "post"})
    assert_generates "/fi/circles/1", controller:"circles", action:"show", locale:"fi", circle_id:1
  end

  test 'should route history' do
    assert_generates "/fi/user/1/historia", controller: "users", action: "history", locale: "fi", id: 1
    assert_generates "/en/user/1/history", controller: "users", action: "history", locale: "en", id: 1
  end
  
  test 'should route settings' do
    assert_generates "/fi/user/1/asetukset", controller: "users", action: "settings", locale: "fi", id: 1
    assert_generates "/en/user/1/settings", controller: "users", action: "settings", locale: "en", id: 1
  end

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
