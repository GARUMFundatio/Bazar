require 'test_helper'

class GruposconfsControllerTest < ActionController::TestCase
  setup do
    @gruposconf = gruposconfs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gruposconfs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gruposconf" do
    assert_difference('Gruposconf.count') do
      post :create, :gruposconf => @gruposconf.attributes
    end

    assert_redirected_to gruposconf_path(assigns(:gruposconf))
  end

  test "should show gruposconf" do
    get :show, :id => @gruposconf.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @gruposconf.to_param
    assert_response :success
  end

  test "should update gruposconf" do
    put :update, :id => @gruposconf.to_param, :gruposconf => @gruposconf.attributes
    assert_redirected_to gruposconf_path(assigns(:gruposconf))
  end

  test "should destroy gruposconf" do
    assert_difference('Gruposconf.count', -1) do
      delete :destroy, :id => @gruposconf.to_param
    end

    assert_redirected_to gruposconfs_path
  end
end
