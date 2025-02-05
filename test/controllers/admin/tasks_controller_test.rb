require "test_helper"

class Admin::TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_tasks_index_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_tasks_destroy_url
    assert_response :success
  end
end
