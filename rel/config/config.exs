use Mix.Config

config :hello, HelloWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  http: [:inet6, port: System.get_env("PORT")],
  url: [host: "boiling-woodland-24991.herokuapp.com", port: System.get_env("PORT")],
  cache_static_manifest: "priv/static/cache_manifest.json",
  root: ".",
  server: true,
  version: Application.spec(:hello, :vsn)

config :hello, Hello.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 1,
  ssl: true
