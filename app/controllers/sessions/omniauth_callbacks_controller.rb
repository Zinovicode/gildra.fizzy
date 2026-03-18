class Sessions::OmniauthCallbacksController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access

  def google_oauth2
    auth = request.env["omniauth.auth"]
    email = auth&.info&.email&.strip&.downcase

    allowed_domain = ENV.fetch("GOOGLE_HD", "gildra.xyz")
    if email.blank? || !email.end_with?("@#{allowed_domain}")
      redirect_to new_session_path, alert: "Sign-in is restricted to #{allowed_domain} accounts."
      return
    end

    identity = Identity.find_or_create_by!(email_address: email)
    identity.update!(google_uid: auth.uid) if identity.google_uid.blank? && auth.uid.present?
    start_new_session_for(identity)

    redirect_to after_authentication_url
  end

  def failure
    redirect_to new_session_path, alert: "Google sign-in failed. Please try again."
  end
end
