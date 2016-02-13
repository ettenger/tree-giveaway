require 'test_helper'

class LogosControllerTest < ActionController::TestCase
  setup do
    @logo = logos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:logos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create logo" do
    assert_difference('Logo.count') do
      post :create, logo: { link: @logo.link, name: @logo.name }
    end

    assert_redirected_to logo_path(assigns(:logo))
  end

  test "should show logo" do
    get :show, id: @logo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @logo
    assert_response :success
  end

  test "should update logo" do
    patch :update, id: @logo, logo: { link: @logo.link, name: @logo.name }
    assert_redirected_to logo_path(assigns(:logo))
  end

  test "should destroy logo" do
    assert_difference('Logo.count', -1) do
      delete :destroy, id: @logo
    end

    assert_redirected_to logos_path
  end
end
