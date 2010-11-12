require 'test_helper'

class UsersessionsControllerTest < ActionController::TestCase
  setup do
    @usersession = usersessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:usersessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create usersession" do
    assert_difference('Usersession.count') do
      post :create, :usersession => @usersession.attributes
    end

    assert_redirected_to usersession_path(assigns(:usersession))
  end

  test "should show usersession" do
    get :show, :id => @usersession.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @usersession.to_param
    assert_response :success
  end

  test "should update usersession" do
    put :update, :id => @usersession.to_param, :usersession => @usersession.attributes
    assert_redirected_to usersession_path(assigns(:usersession))
  end

  test "should destroy usersession" do
    assert_difference('Usersession.count', -1) do
      delete :destroy, :id => @usersession.to_param
    end

    assert_redirected_to usersessions_path
  end
end
