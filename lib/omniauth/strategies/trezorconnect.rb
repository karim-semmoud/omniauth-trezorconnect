require 'omniauth'
require 'bitcoin'
require 'securerandom'

module OmniAuth
  module Strategies
    class Trezorconnect
      include OmniAuth::Strategy

      option :trezor_site
      option :trezor_email
      option :visual_challenge
      option :hidden_challenge
      option :fields, [:public_key, :signature]
      option :uid_field, :public_key

      def request_phase
        visual_challenge = options[:challenge_visual]
        visual_challenge ||= Time.now.strftime("%Y-%m-%d %H:%M:%S")

        hidden_challenge = options[:hidden_challenge]
        hidden_challenge ||= SecureRandom.hex(32)

        trezor_site = options[:trezor_site]
        trezor_email = options[:trezor_email]

        session['omniauth.trezor_visual_challenge'] = visual_challenge
        session['omniauth.trezor_hidden_challenge'] = hidden_challenge

        OmniAuth::Form.build(
          title: "Trezor Login",
          url: callback_path,
          header_info: <<-HTML
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js" type="text/javascript"></script>
            <script src="https://connect.trezor.io/9/trezor-connect.js"></script>
            <script type='text/javascript'>
              function trezorLogin() {
                TrezorConnect.init({
                  lazyLoad: true,
                  manifest: {
                    email: '#{trezor_email}',
                    appUrl: '#{trezor_site}',
                  },
                });

                TrezorConnect.requestLogin({
                  challengeHidden: '#{hidden_challenge}',
                  challengeVisual: '#{visual_challenge}'
                })
                .then((result) => {
                  if (result.success) {
                    $('input[name=public_key]').val(result.payload.publicKey);
                    $('input[name=signature]').val(result.payload.signature);
                    $('form').submit();
                  } else {
                    console.log('Error:', result.payload.error);
                  }
                });
               
              }
              $(function() {
                $('button').click(function() {
                  trezorLogin();
                  return false;
                });
              });
            </script>
          HTML
        ) do |f|
          f.input_field('hidden', 'public_key')
          f.input_field('hidden', 'signature')
          f.html "<p>Logging in at: #{visual_challenge}</p>"
        end.to_response
      end

      def callback_phase
        verified = verify_signature(
            extra[:public_key],
            extra[:signature],
            extra[:hidden_challenge],
            extra[:visual_challenge]
        )
        if verified
          super
        else
          fail!(:invalid_credentials)
        end
      end

      uid do
        request.params['public_key']
      end

      extra do
        {
          hidden_challenge: session['omniauth.trezor_hidden_challenge'],
          visual_challenge: session['omniauth.trezor_visual_challenge'],
          public_key: request.params['public_key'],
          signature: request.params['signature'],
        }
      end


      private
      def verify_signature(pubkey, signature, challenge_hidden='', challenge_visual='')
        address = Bitcoin.pubkey_to_address(pubkey)
        sha256 = Digest::SHA256.new
        signature = [signature.htb].pack('m0')
        message = sha256.digest(challenge_hidden.htb) + sha256.digest(challenge_visual)
        Bitcoin.verify_message(address, signature, message)
      end
    end
  end
end
