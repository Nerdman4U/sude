# coding: utf-8
require 'test_helper'

class RouteTest < ActionDispatch::IntegrationTest

  test 'should route create vote proposal' do
    assert_recognizes({controller:"vote_proposals", action:"create", locale:"fi"},{path:"/fi/#{CGI.escape('äänestysehdotukset')}", method:"post"})
  end

  test 'should route new vote proposal' do
    assert_generates "fi/#{CGI.escape('äänestysehdotukset')}/1/uusi", controller: "vote_proposals", action: "new", locale: "fi", circle_id: 1
  end

  test 'should route circles' do
    assert_generates "/fi/puhepiirit", controller: "circles", action: "index", locale: "fi"
    assert_recognizes({controller: "circles", action: "create", locale: "fi"},{path: "/fi/puhepiirit", method: "post"})
    assert_generates "/fi/puhepiirit/1", controller:"circles", action:"show", locale:"fi", circle_id:1
  end

  test 'should route history' do
    assert_generates "/fi/user/historia", controller: "users", action: "history", locale: "fi"
    assert_generates "/en/user/history", controller: "users", action: "history", locale: "en"
  end
  
  test 'should route settings' do
    assert_generates "/fi/user/asetukset", controller: "users", action: "settings", locale: "fi"
    assert_generates "/en/user/settings", controller: "users", action: "settings", locale: "en"
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
