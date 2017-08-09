require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
  end
  test 'should set locale' do
    get "/fi"
    # assert_equal I18n.locale, "fi"
  end
  
  test 'should set a key to a session and get a key from a session' do
    get "/fi"
    controller.session.clear
    
    handler = controller.send(:session_handler)
    assert handler
    assert handler.set("foo", "bar")
    assert_equal controller.session["foo"], {:value => "bar"}
    assert_equal handler.get("foo"), "bar"
    
    assert handler.set(["foo","foo2"], "bar2")
    assert_equal controller.session[:foo], {:value => "bar", :foo2 => { :value => "bar2" }}
    assert_equal controller.session[:foo][:foo2], {:value => "bar2"}
    assert_equal handler.get([:foo,:foo2]), "bar2"

    assert handler.set(["foo","foo2"], nil)
    assert_equal controller.session[:foo], {:value => "bar", :foo2 => { :value => nil }}
    assert_equal handler.get("foo"), "bar"    
  end
  
end
