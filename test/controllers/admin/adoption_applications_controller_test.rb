require "test_helper"

class Admin::AdoptionApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_adoption_applications_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_adoption_applications_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_adoption_applications_update_url
    assert_response :success
  end
end
