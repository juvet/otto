defmodule Otto.Factory do
  use ExMachina.Ecto, repo: Otto.Repo

  use Otto.IdentityFactory
end
