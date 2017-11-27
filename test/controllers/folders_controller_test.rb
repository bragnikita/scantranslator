  require 'test_helper'

  class FoldersControllerTest < ActionDispatch::IntegrationTest

    def setup
      @parent = Folder.create(name: 'parent')
      @folder = Folder.create(name: 'name', parent: @parent)
    end

    test 'creates articles' do
      get folders_path, as: :json
      assert_response 200
      assert_equal 'index', @controller.action_name

      body = @response.body
      body = JSON.parse body
      p mu_pp body
      assert_equal 4, body['data'].size
      folder = body['data'].find {|f| f['id'] == @folder.id}
      assert_not_nil folder
      assert_equal  @folder.id, folder['id']
      assert_equal '/parent/name', folder['path']
      assert_equal  @parent.id,folder['parent']

    end

    test 'show_content' do
      get folder_path(@folder.id), as: :json
      assert_response 200
    end

    test 'select_with_query' do
      get '/folder?path=/parent', as: :json
      assert_response 200
    end

    test 'select_with_query_not_exists' do
      get '/folder?path=/no_exists', as: :json
      assert_response 404
    end

    test 'select without query' do
      get "/folder", as: :json
      assert_response 200
      body = JSON.parse @response.body
      assert_equal 3, body['folders'].size
      col = body['folders'].select {|h| h.value? 'parent'}[0].values
      assert_includes col ,@parent.id
      assert_includes col,"parent"
      assert_includes col,nil
    end

    test 'Create new folder with no parent' do
      post folders_path, params: {name: 'new_folder'}, as: :json
      @folder = Folder.order("id").last
      assert_not_nil @folder
      assert_equal "new_folder", @folder.name
      assert_response :success
      body = JSON.parse @response.body
      p body
      assert body > {
        'result' => 0,
        'id' => @folder.id,
        'path' => '/new_folder'
      }
    end

    test 'Edit folder name' do
      put folder_path(@folder.id), params: {name: 'renamed_folder'}, as: :json
      assert_response :success
      @folder.reload
      assert_equal 'renamed_folder', @folder.name
    end

    test 'Edit folder name with error (already created' do
      dup = Folder.create(name: 'other_name', parent: @parent)
      put folder_path(dup.id), params: {name: 'name'}, as: :json
      assert_response 400
      assert_equal -1,JSON.parse(@response.body)['result']
    end

    test 'Destroy folder' do
      delete folder_path(@folder.id), as: :json
      assert_response 200
      refute Folder.exists?(@folder.id)
    end

    test 'Try to destroy parent' do
      delete folder_path(@parent.id), as: :json
      assert_response 402
      assert Folder.exists? @parent.id
    end

    test 'Try to get not non-existed folder' do
      get folder_path(-100), as: :json
      assert_response 404
    end

    test 'Get upload page for folder' do
      get upload_folder_path(@folder)
      assert_response 200
    end
  end