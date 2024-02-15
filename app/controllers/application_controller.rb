class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  def authenticate_request
    if request.headers["Authorization"].nil?
      render json: { error: "Not Authorized" }, status: :unauthorized
      return
    end

    token = request.headers["Authorization"].sub("Bearer ", "")
    cognito_identity_provider = Aws::CognitoIdentityProvider::Client.new(region: ENV['AWS_REGION'])

    begin
      cognito_user = cognito_identity_provider.get_user({
        access_token: token.strip,
      })
    rescue => e
      cognito_user = nil
    end

    if cognito_user
      id = cognito_user.user_attributes.find { |attr| attr.name == "sub" }.value
      email = cognito_user.user_attributes.find { |attr| attr.name == "email" }.value
      email_verified = cognito_user.user_attributes.find { |attr| attr.name == "email_verified" }.value

      @current_user = User.find_or_create_by(id: id) do |user|
        user.email = email
        user.email_verified = email_verified
      end
      pp current_user

      # @current_user = {
      #   id: cognito_user.user_attributes.find { |attr| attr.name == "sub" }.value,
      #   email: cognito_user.user_attributes.find { |attr| attr.name == "email" }.value,
      #   email_verified: cognito_user.user_attributes.find { |attr| attr.name == "email_verified" }.value,
      # }
    else
      @current_user = nil
      render json: { error: "Not Authorized" }, status: :unauthorized
    end
  end
end
