require 'test_helper'

class ConfsControllerTest < ActionController::TestCase
  setup do
    @conf = confs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:confs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conf" do
    assert_difference('Conf.count') do
      post :create, :conf => @conf.attributes
    end

    assert_redirected_to conf_path(assigns(:conf))
  end

  test "should show conf" do
    get :show, :id => @conf.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @conf.to_param
    assert_response :success
  end

  test "should update conf" do
    put :update, :id => @conf.to_param, :conf => @conf.attributes
    assert_redirected_to conf_path(assigns(:conf))
  end

  test "should destroy conf" do
    assert_difference('Conf.count', -1) do
      delete :destroy, :id => @conf.to_param
    end

    assert_redirected_to confs_path
  end
end
