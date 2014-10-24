require 'test_helper'

class Admin::ThemeFilesControllerTest < ActionController::TestCase
  setup do
    @theme_file = theme_files(:aachen_open_index)
    @competition = @theme_file.competition
    login_as(@competition.users.first)
  end

  test '#edit' do
    get :edit, id: @theme_file.id
    assert_response :success
  end

  test '#edit theme file that has theme has back button to theme page' do
    get :edit, id: @theme_file.id
    url = admin_competition_theme_files_path(@competition)
    assert @response.body.include?(url)
  end

  test '#edit theme file that has competition has back button to competition' do
    theme_file = theme_files(:template_index)
    get :edit, id: theme_file.id
    url = admin_theme_theme_files_path(theme_file.theme)
    assert @response.body.include?(url)
  end

  test '#update' do
    params = {
      filename: 'foobar.html',
      content: 'foobar!'
    }

    patch :update, id: @theme_file.id, theme_file: params

    assert_redirected_to edit_admin_theme_file_path(assigns(:theme_file))
    assert_attributes(params, @theme_file.reload)
  end

  test '#destroy' do
    assert_difference('ThemeFile.count', -1) do
      delete :destroy, id: @theme_file.id
    end

    assert_redirected_to admin_competition_theme_files_path(@competition)
  end

  test '#show_image' do
    theme_file = theme_files(:aachen_open_logo)
    get :show_image, id: theme_file.id
    assert_response :ok
  end

  test '#show_image on a theme file that is not an image returns 404' do
    get :show_image, id: @theme_file.id
    assert_response :not_found
  end
end
