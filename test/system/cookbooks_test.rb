require "application_system_test_case"

class CookbooksTest < ApplicationSystemTestCase
  setup do
    @cookbook = cookbooks(:one)
  end

  test "visiting the index" do
    visit cookbooks_url
    assert_selector "h1", text: "Cookbooks"
  end

  test "should create cookbook" do
    visit cookbooks_url
    click_on "New cookbook"

    fill_in "Description", with: @cookbook.description
    fill_in "Title", with: @cookbook.title
    fill_in "User", with: @cookbook.user_id
    click_on "Create Cookbook"

    assert_text "Cookbook was successfully created"
    click_on "Back"
  end

  test "should update Cookbook" do
    visit cookbook_url(@cookbook)
    click_on "Edit this cookbook", match: :first

    fill_in "Description", with: @cookbook.description
    fill_in "Title", with: @cookbook.title
    fill_in "User", with: @cookbook.user_id
    click_on "Update Cookbook"

    assert_text "Cookbook was successfully updated"
    click_on "Back"
  end

  test "should destroy Cookbook" do
    visit cookbook_url(@cookbook)
    click_on "Destroy this cookbook", match: :first

    assert_text "Cookbook was successfully destroyed"
  end
end
