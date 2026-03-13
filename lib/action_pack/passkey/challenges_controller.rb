class ActionPack::Passkey::ChallengesController < ActionController::Base
  COOKIE_NAME = :action_pack_passkey_challenge

  include ActionPack::Passkey::Request

  def create
    challenge = ActionPack::WebAuthn::PublicKeyCredential::Options.new(
      challenge_expiration: Rails.configuration.action_pack.web_authn.request_challenge_expiration
    ).challenge

    cookies.encrypted[COOKIE_NAME] = { value: challenge, httponly: true, same_site: :strict, secure: !request.local? && request.ssl? }

    render json: { challenge: challenge }
  end
end
