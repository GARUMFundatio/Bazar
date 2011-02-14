require 'test_helper'

class ActividadesControllerTest < ActionController::TestCase
  setup do
    @actividad = actividades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:actividades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create actividad" do
    assert_difference('Actividad.count') do
      post :create, :actividad => @actividad.attributes
    end

    assert_redirected_to actividad_path(assigns(:actividad))
  end

  test "should show actividad" do
    get :show, :id => @actividad.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @actividad.to_param
    assert_response :success
  end

  test "should update actividad" do
    put :update, :id => @actividad.to_param, :actividad => @actividad.attributes
    assert_redirected_to actividad_path(assigns(:actividad))
  end

  test "should destroy actividad" do
    assert_difference('Actividad.count', -1) do
      delete :destroy, :id => @actividad.to_param
    end

    assert_redirected_to actividades_path
  end
end
