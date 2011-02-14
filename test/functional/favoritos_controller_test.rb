require 'test_helper'

class FavoritosControllerTest < ActionController::TestCase
  setup do
    @favorito = favoritos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favoritos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorito" do
    assert_difference('Favorito.count') do
      post :create, :favorito => @favorito.attributes
    end

    assert_redirected_to favorito_path(assigns(:favorito))
  end

  test "should show favorito" do
    get :show, :id => @favorito.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @favorito.to_param
    assert_response :success
  end

  test "should update favorito" do
    put :update, :id => @favorito.to_param, :favorito => @favorito.attributes
    assert_redirected_to favorito_path(assigns(:favorito))
  end

  test "should destroy favorito" do
    assert_difference('Favorito.count', -1) do
      delete :destroy, :id => @favorito.to_param
    end

    assert_redirected_to favoritos_path
  end
end
