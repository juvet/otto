defmodule Otto.Query do
  defmacro __using__(opts) do
    module = Keyword.get(opts, :module)

    quote do
      use Ecto.Schema

      alias Otto.Repo

      import Ecto.Changeset
      import Ecto.Query

      def build(params) do
        changeset(struct(unquote(module)), params)
      end

      def create(params) do
        struct(unquote(module))
        |> changeset(params)
        |> Repo.insert()
      end

      def get(id) do
        unquote(module)
        |> Repo.get(id)
      end

      def get!(id) do
        unquote(module)
        |> Repo.get!(id)
      end
    end
  end
end
