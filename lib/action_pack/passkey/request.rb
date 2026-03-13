module ActionPack::Passkey::Request
  extend ActiveSupport::Concern

  included do
    before_action do
      ActionPack::WebAuthn::Current.host = request.host
      ActionPack::WebAuthn::Current.origin = request.base_url
      ActionPack::WebAuthn::Current.challenge = cookies.encrypted[ActionPack::Passkey::ChallengesController::COOKIE_NAME]
      cookies.delete(ActionPack::Passkey::ChallengesController::COOKIE_NAME)
    end
  end

  def passkey_creation_params(param: :passkey)
    params.expect(param => [ :client_data_json, :attestation_object, transports: [] ])
  end

  def passkey_request_params(param: :passkey)
    params.expect(param => [ :id, :client_data_json, :authenticator_data, :signature ])
  end

  def passkey_request_options(**options)
    ActionPack::Passkey.request_options(**options)
  end

  def passkey_creation_options(**options)
    ActionPack::Passkey.creation_options(**options)
  end
end
