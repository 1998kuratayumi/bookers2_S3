require 'test_helper'

class BookCommentControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get book_comment_create_url
    assert_response :success
  end

  test "should get destroy" do
    get book_comment_destroy_url
    assert_response :success
  end

end
