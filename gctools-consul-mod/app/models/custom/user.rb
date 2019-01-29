require_dependency Rails.root.join('app', 'models', 'user').to_s

class User < ActiveRecord::Base

    has_one :test
    scope :tests,     -> { joins(:test) }

    # Get the existing user by email if the provider gives us a verified email.
    def self.first_or_initialize_for_oauth(auth)
        oauth_email           = auth.info.email
        oauth_user            = User.find_by(email: oauth_email)

        oauth_user || User.new(
        username:  auth.info.name || auth.uid,
        email: oauth_email,
        oauth_email: oauth_email,
        password: Devise.friendly_token[0, 20],
        terms_of_service: '1',
        confirmed_at: DateTime.current
        )
    end

    def test?
        test.present?
    end
end
