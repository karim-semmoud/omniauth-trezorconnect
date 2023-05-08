# omniauth-trezorconnect

`omniauth-trezorconnect` provides an [OmniAuth][omniauth] strategy for [Trezor Connect Version 9][trezor_connect].

With this strategy your users can use popular [Trezor Wallet][trezor] to login to your website.

[omniauth]: https://github.com/omniauth/omniauth
[trezor_connect]: https://github.com/trezor/trezor-suite/tree/develop/packages/connect
[trezor]: https://trezor.io

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-trezorconnect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-trezorconnect

## Usage

In Rails app, add config/initializers/omniauth.rb:
Trezor requires requires that you, as a Trezor Connect integrator, share your e-mail and application url with us. This provides with the ability to reach you in case of any required maintenance. This subscription is mandatory.
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :trezor, client_options: { 
                        trezor_site: "https://examplesite.com",
                        trezor_email: "email@example.com"
                                    }
end
```
### Options

These are the options you can specify that are relevant to Omniauth Trezor:

Challenge-response authentication via TREZOR. To protect against replay attacks, you must use a server-side generated and randomized challenge_hidden for every attempt. You can also provide a visual challenge that will be shown on the device.

* `:visual_challenge` - Text that will be shown on the device (defaults to `Time.now.strftime("%Y-%m-%d %H:%M:%S")`)
* `:hidden_challenge` - Hidden randomized hex string used to protect agains replay attacks (defaults to `SecureRandom.hex(32)`)

### Callback phase

After successful authentication `request.env['omniauth.auth'].extra` contains all data that was used to verify the signature: `visual_challenge`, `hidden_challenge`, `signature` and `public_key` for your additional needs (ie. audit log).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/karim-semmoud/omniauth-trezorconnect.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## A Special thanks 
This gem is based on the gem [omniauth-trezor](https://github.com/kraxnet/omniauth-trezor).
A special thanks goes to [Kraxnet](https://github.com/kraxnet) for his amazing contribution

## Whats new ?
* Updgrade Trezor Connect from version 8 to version 9

* Upgrade Omniauth gem from version 1 to version 2

* Add mandatory App URL and Email to be shared with Trezor