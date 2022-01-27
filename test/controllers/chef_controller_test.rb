require "test_helper"

class ChefControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chef_index_url
    assert_response :success
  end

  test "should get show" do
    get chef_show_url
    assert_response :success
  end
end
