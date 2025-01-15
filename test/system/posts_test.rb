require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "should create post" do
    visit posts_url
    click_on "New post"

    fill_in "Body", with: @post.body
    fill_in "Date", with: @post.date
    fill_in "Title", with: @post.title
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back to posts"
  end

  test "should update Post" do
    visit post_url(@post)
    click_on "Edit", match: :first

    fill_in "Body", with: @post.body
    fill_in "Date", with: @post.date
    fill_in "Title", with: @post.title
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back to posts"
  end

  test "should destroy Post" do
    visit post_url(@post)
    click_on "Delete", match: :first

    assert_text "Post was successfully destroyed"
  end
end
