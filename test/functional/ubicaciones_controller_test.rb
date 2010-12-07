require 'test_helper'

class UbicacionesControllerTest < ActionController::TestCase
  setup do
    @ubicacion = ubicaciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ubicaciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ubicacion" do
    assert_difference('Ubicacion.count') do
      post :create, :ubicacion => @ubicacion.attributes
    end

    assert_redirected_to ubicacion_path(assigns(:ubicacion))
  end

  test "should show ubicacion" do
    get :show, :id => @ubicacion.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ubicacion.to_param
    assert_response :success
  end

  test "should update ubicacion" do
    put :update, :id => @ubicacion.to_param, :ubicacion => @ubicacion.attributes
    assert_redirected_to ubicacion_path(assigns(:ubicacion))
  end

  test "should destroy ubicacion" do
    assert_difference('Ubicacion.count', -1) do
      delete :destroy, :id => @ubicacion.to_param
    end

    assert_redirected_to ubicaciones_path
  end
end
