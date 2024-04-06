# Vaccination Card

## Introduction

An API that simulates the operation of a vaccination card. Within it, you can register a vaccine dose and have your vaccination card at your disposal.

## Technologies

- **[Docker](https://docs.docker.com)** and **[Docker Compose](https://docs.docker.com/compose/)** to create our development and test environments;
- **[Postgresql](https://www.postgresql.org/)** to store the data;
- **[Elixir](https://elixir-lang.org/)** language;
- **[Phoenix](https://www.phoenixframework.org/)** web framework.

## Prerequisites

- [docker](https://docs.docker.com/engine/install/ubuntu/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [elixir](https://elixir-lang.org/install.html)
- [phoenix](https://hexdocs.pm/phoenix/installation.html)

## Getting Started

Make sure that you have the prerequisites installed, then clone the repository:
```bash
$ git clone https://github.com/brunoguedesit/vaccination_card
```

### Running Locally

```bash
# Get project dependencies & run the stack
$ mix deps.get
$ mix phx.server

# Run the tests
$ mix test

```

### Running Docker

Change the hostname value from both `config/dev.exs` and `config/test.exs` configuration files:

```elixir
config :vaccination_card, VaccinationCard.Repo,
  hostname: "database",
```

Now, run with docker-compose:

```bash
# Run the stack
$ docker-compose up

# Run the tests
$ docker-compose exec vaccination_card mix test
```
**WARNING:** if you want to switch to local run, delete your `_build` folder to compile without any errors.

## Available Routes

For more datails, you can check the [Postman API documentation](https://documenter.getpostman.com/view/3095470/2sA35LX19A)

### Application Routes

| Routes                  | Description                                  | Methods HTTP |
|------------------------|--------------------------------------------|--------------|
|/api/auth/signup                | register a new user account    |  POST         |
|/api/auth/signin                 | login to get a JWT          | POST         |
|/api/vaccine_card/  | get user vaccine_card                          | GET         |
|/api/vaccine_types  | get a list of vaccines and yours ids   | GET         |
|/api/vaccines/take-dose   | take a dose of a vaccine                      | POST         |


### Admin Access Routes

| Routes                  | Description                                  | Methods HTTP |
|------------------------|--------------------------------------------|--------------|
|/api/vaccines/register                | insert a vaccine into vaccine types list  |  POST         |
|/api/vaccines/delete                 | delete a vaccine of vaccine types list    | GET         |

