# TargetMvd

## Installing dependencies

To run the project you need to have Elixir and Erlang installed. The best way to install them is using a version manager (in this case `asdf`), from [the guide](https://asdf-vm.com/#/core-manage-asdf-vm):

```bash
brew install asdf
# for zsh
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
# for bash on Mac
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profil
# dependencies
brew install \
  coreutils automake autoconf openssl \
  libyaml readline libxslt libtool unixodbc \
  unzip curl
# Erlang
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 22.1.5
# Elixir
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.9.2
```

An easier alternative is to just use `brew`:

```bash
brew install elixir
```

After installing Elixir you'll need to install the phoenix package through hex, Elixir's package manager:

```bash
mix archive.install hex phx_new 1.4.10
```

You'll also need to have Postgres installed, you can get the latest version with `brew`:

```bash
brew install postgres
brew services start postgres
```

## Serving

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
