require 'test_helper'

class GiveawaysControllerTest < ActionController::TestCase
  setup do
    @giveaway = giveaways(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:giveaways)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create giveaway" do
    assert_difference('Giveaway.count') do
      post :create, giveaway: { description: @giveaway.description, location: @giveaway.location, name: @giveaway.name, time: @giveaway.time }
    end

    assert_redirected_to giveaway_path(assigns(:giveaway))
  end

  test "should show giveaway" do
    get :show, id: @giveaway
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @giveaway
    assert_response :success
  end

  test "should update giveaway" do
    patch :update, id: @giveaway, giveaway: { description: @giveaway.description, location: @giveaway.location, name: @giveaway.name, time: @giveaway.time }
    assert_redirected_to giveaway_path(assigns(:giveaway))
  end

  test "should destroy giveaway" do
    assert_difference('Giveaway.count', -1) do
      delete :destroy, id: @giveaway
    end

    assert_redirected_to giveaways_path
  end
end
