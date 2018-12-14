[![Build Status](http://drone.draftapp.io/api/badges/draftappio/api/status.svg)](http://drone.draftapp.io/draftappio/api)
[![Docker Repository on Quay](https://quay.io/repository/draftappio/api/status?token=37b0870e-46fb-4f40-b98f-76aafaf28cf1 "Docker Repository on Quay")](https://quay.io/repository/draftappio/api)

![Draft Logo](https://dl.dropboxusercontent.com/u/71605080/draftdarklogo.png)

# Draft Agnostic Rails API
The agnostic Rails API that powers the Draft Chrome extension, Angular web and mobile applications.

# Local Installation
1. Clone the repo
2. Start MongoDB daemon
3. Start Redis server
4. Create your `config/secrets.yml` config file
5. Start the Rails server via `rails server or rails s`

# Puma

To install Puma:

`gem install puma -v '3.6.0' -- --with-opt-dir=/usr/local/opt/openssl`

# Secrets.yml
You Should create a file under `config` directory for your application secrets. It should conform to the following style:

```yml
development: &development
  secret_key_base: token

production:
  secret_key_base: token

test:
  <<: *development

github_client_id: token
github_client_secret: token

```
