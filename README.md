OTTO
====

An example chatbot built using [Juvet](https://github.com/juvet/juvet) that supports some dev ops.

## DESCRIPTION

Automates some common operations that developers perform on an almost daily basis through the use of conversation user interfaces over Slack.

* Creates a project under an organization on GitHub (currenly underway)
* Generates a README from an organization template on GitHub (coming soon)

## INSTALLATION

* Clone the repo

```
git clone https://github.com/juvet/otto
```

* Create a Slack app

Visit [https://api.slack.com/apps](https://api.slack.com/apps) and copy your client id and client secret after it is created.

* Add your credentials

```
cp .env.sample .env.dev
```

Enter your client id and client secret you copied above

* Setup the database

```
mix ecto.setup
```

* Run the server

```
mix phx.server
```

### Hosting

(Coming Soon - Heroku button)

## USAGE

### Authorize with GitHub

Once you add the bot to your Slack team, you will be sent a link to authorize your GitHub account.

If you need to re-authorize or otherwise need to authorize with GitHub, you can direct message otto with simply `authorize`.

### Create a project on GitHub

You can create a new project on GitHub by using the following conversations with the bot directly:

* Create a project org/project
* Create project under org
* Create a project under org
* Create a project

## TESTING

You can run the tasks with the standard mix command:

```
mix test
```

## COMMUNITY

### Contributing

1. Clone the repository `git clone https://github.com/juvet/otto`
1. Create a feature branch `git checkout -b my-awesome-feature`
1. Codez!
1. Commit your changes (small commits please)
1. Push your new branch `git push origin my-awesome-feature`
1. Create a pull request `hub pull-request -b juvet:master -h juvet:my-awesome-feature`

## Copyright and License

Copyright (c) 2018, Jamie Wright.

Juvet source code is licensed under the [MIT License](LICENSE.md).
