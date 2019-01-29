class Test::Legislation::BaseController < Test::BaseController
  include FeatureFlags

  feature_flag :legislation

  helper_method :namespace

  private

    def namespace
      "test"
    end

end
