require 'test_helper'

class WordSetsControllerTest < ActionController::TestCase
  setup do
    @word_set = word_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:word_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create word_set" do
    assert_difference('WordSet.count') do
      post :create, word_set: { visits: @word_set.visits }
    end

    assert_redirected_to word_set_path(assigns(:word_set))
  end

  test "should show word_set" do
    get :show, id: @word_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @word_set
    assert_response :success
  end

  test "should update word_set" do
    patch :update, id: @word_set, word_set: { visits: @word_set.visits }
    assert_redirected_to word_set_path(assigns(:word_set))
  end

  test "should destroy word_set" do
    assert_difference('WordSet.count', -1) do
      delete :destroy, id: @word_set
    end

    assert_redirected_to word_sets_path
  end
end
