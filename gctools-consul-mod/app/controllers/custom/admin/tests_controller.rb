class Admin::TestsController < Admin::BaseController
    load_and_authorize_resource
  
    def index
      @tests = @tests.page(params[:page])
    end
  
    def search
      @users = User.search(params[:name_or_email])
                   .includes(:test)
                   .page(params[:page])
                   .for_render
    end
  
    def create
      @test.user_id = params[:user_id]
      @test.save
  
      redirect_to admin_tests_path
    end
  
    def destroy
      @test.destroy
      redirect_to admin_tests_path
    end
  end