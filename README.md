# Shiny System Design

System design for Shiny developers based around Shinyproxy deployment.

## Architecture

This project is built around the idea of a domain oriented microservices architecture.

![architecture-diagram](./architecture.svg)

Every white box on the diagram represents a single docker container.

The containers are grouped based on the domain boundaries:

- Authentication
- Shinyproxy
- Monitoring
- Cache
- Services

...thus comprising a total of 5 domains.

>[!NOTE]
>**Persistent Storage** is not an actual domain, but rather
>a visual convenience to demonstrate the dependency on the
> file system of a host server.

There are 4 types of lines on the diagrams that represent different
kinds of data flow:

- *Thick lines* are the main inter-domain flow of logic
- *Thin lines* inside the domain boundaries represent intra-domain communication
- *Dotted lines* are reserved for telemetry and monitoring flows
- *Dashed lines* represent filesystem usage (via docker volumes)

## About the Repository

This project is developed as a big monorepo to avoid any induced complexity
related to version control management (git), e.g. git submodules.

Every domain mentioned above is developed and maintained in its own folder,
has its own Docker Compose Stack defined in a corresponding *compose* file,
and has its own Build Group defined in the *docker-bake* file.

## Setup and Configuration

### System Requirements

Please install this software to have the best deployment experience,
and to be able to follow along the instructions below:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Taskfile](https://taskfile.dev/)

### Build and Deploy

Run the following commands to build and start all docker services:

```sh
task build
task start
task logs
task stop
```

### Configure Authentication

To setup OpenLDAP via the Admin UI:

- Visit [http://localhost:6480/setup](http://localhost:6480/setup)
- Enter the admin password, (`admin` is the default)
- Do not change anything, click "Next" button
- Click "Create new account" button
- Complete the form (you may skip email)
  - This is going to be the first user in the system, i.e. *the* admin
  - It is recommended to give them a distinct name, e.g. `super-admin`
- Once done, click "Finish" button
- Proceed to login
  - By default, login is the combination of first and last names separated with a `-`
- You are now logged in as the admin user
  - You can now add new users and control their group
  - Remember, that the group (either `admins` or `users` will have effect on what the user will see in Shinyproxy!)
- The LDAP configuration is persisted via a docker volume
  - Only one time configuration is required

## Monitoring

Monitoring domain consists of two "services": PostgreSQL database to
store metrics and logs, and Grafana to visualize them.

Shinyproxy is configured to send usage statistics to the PostgreSQL DB,
and the Shiny app is instrumented with shiny.telemetry, which also
sends its logs to the PostgreSQL DB.

### Telemetry

### Metrics

Configure grafana to properly display metrics.
Configure grafana to automatically load JSON config at build time.

#### Example queries

Table of telemetry events

```sql
with inputs as (
  select
    details :: json -> 'id' ->> 0 as input_id,
    details :: json -> 'value' ->> 0 as input_value
  from event_log
  where
    1 = 1
    and details :: json -> 'id' ->> 0 is not null
    and "time" BETWEEN $__timeFrom() and $__timeTo()
)

select input_id, input_value, count(*) as n
from inputs
group by input_id, input_value
order by n desc
```

## Development

### Devcontainers

In my personal experience, projects written in Python and JavaScript (TypeScript) often do not require any special configuration.

But for R projects I tend to always configure a devcontainer to avoid any
implicit system dependencies or build-from-source caveats.

In fact, the core R/Shiny application of this project comes preconfigured
with a [devcontainer](./shinyproxy/app/.devcontainer/devcontainer.json).

### Git Commits

It is strongly recommended to use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).
Furthermore, for large projects like this I recommend to incorporate
the domain-oriented approach described in the Architecture section
in the commit messaging structure by prefixing every commit title the following way:

- `[root]` if a change affects overall configuration of the project
- `[domain]` if a change affects configuration of a certain domain, or a change affects multiple subdomains
- `[domain/subdomain]` if a change is limited to a specific service

See example below, an excerpt of the git commit history of this project:

```txt
ca8ebe8 [root] refactor: overall improvement of start & stop commands
59f2e32 [monitoring] refactor: define dockerfiles for loki and alloy
5cbbbd2 [root] chore: use svg img of arch diagram
269a6dc [root] refactor: improve diagram positioning
28a467b [root] feat: add loki and alloy to the architecture diagram
bc43142 [monitoring] feat: configure loki and alloy
2bc4a7f [shinyproxy/proxy] feat: mount logs to the host disk
84d0811 [shinyproxy/proxy] chore: do not dump request info
2139d10 [shinyproxy/proxy] chore: update app description
481dfc9 [root] refactor: update architecture scheme
1535d60 [root] refactor: read existing env file
14ac816 [cache/cache_db] refactor: rename kv_database into cache_db
71501ab [monitoring/db] refactor: rename monitoring_db
```
