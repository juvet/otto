defmodule Otto.IdentityFactory do
  defmacro __using__(_opts) do
    quote do
      alias Otto.Identity

      def slack_identity_factory do
        %Identity{
          access_token: sequence("SLACK_TOKEN"),
          provider: "slack",
          uid: sequence("SLACK_UID"),
          username: sequence("SLACK_USER")
        }
      end
    end
  end
end
