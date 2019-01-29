class Test::BaseController < ApplicationController
    layout 'admin'
  
    before_action :authenticate_user!
  
    skip_authorization_check
  
    private
  
      def verify_test
        raise CanCan::AccessDenied unless current_user.try(:test?) || current_user.try(:administrator?)
      end
  
  end
  