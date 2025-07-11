# Shiny System Design

System design for Shiny developers based around Shinyproxy deployment.

This material was first presented at the **[useR! 2025](https://user2025.r-project.org/)** conference.

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

Please note that **Persistent Storage** is not an actual domain, but rather
a visual convenience to demonstrate the dependency on the
 file system of a host server.

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

This is a fairly complex project, so to manage it we need to install a couple of tools:

#### [Docker Desktop](https://www.docker.com/products/docker-desktop/)

Docker is at the heart of this whole setup: all services are docker containers that are run from docker images.

Personally, I recommend to install Docker Desktop distribution
for a few reasons:

- It has a nice interface to inspect running containers (logs, filesystem, access to the terminal)
- Docker Desktop comes with Compose and Bake so you don't have to worry about installing them separately
  - Compose is a well-known docker tool to manage multiple services, their environment variables, ports and networks
  - [Bake](https://docs.docker.com/build/bake/) is a relatively new tool that allows to centrally configure image building options
  - If it helps you, I like to think that Docker Compose is a toolf for containers, while Docker Bake is a tool for images

#### [Taskfile](https://taskfile.dev/)

Taskfile is a CLI application that allows you to create and control "tasks" - any commands that can be executed in the terminal.

This is often not a mandatory tool - I could just add shell commands to the README, and then just copy-paste them into the terminal every time.

However, in this case, Taskfile helps ensure sure that this project is platform-agnostic.
For example, we need to copy *variables.env* file into the Shinyproxy folder before we build docker images.
Taskfile handles this problem smoothly by running an appropriate task whether is on [Windows](taskfile.yml#L69) or a [Unix](taskfile.yml#L74) system.

#### Configuration Files

| Name | Config File |
|------|--------------|
|Taskfile|[taskfile.yml](taskfile.yml)|
|Docker Compose|[docker-compose.yml](docker-compose.yml)|
|Docker Bake|[docker-bake.hcl](docker-bake.hcl)|

#### Available Tasks

You can check the pre-configured tasks by running the following command:

```sh
task --list
```

### Build

To avoid any confusion, all services used in this project
are built into dedicated docker images and given a corresponding docker tag.

For example, we use PostgreSQL to store telemetry logs,
so we need a Postgres Docker Image.
We could pull & run postgres image directly via Docker Compose,
but instead I suggest that we create a minimal [Dockerfile](./monitoring/monitoring_db/Dockerfile),
add a build entry to the [Bakefile](./docker-bake.hcl#L68), and only then run it via [Compose](./monitoring/compose.yml#L5)

This approach is debatable, but I think it adds clarity:
all images used in the project are prefixed with `shiny-system-design`,
and at any time we can add `COPY` or any other Docker Layer to the corresponding Dockerfile without disrupting the overall process.

Also, notice how in this case the service is called `monitoring_db`,
thus abstracting away the actual RDBS being used.

Anyway, to build all docker images configured in the Bakefile
simply run:

```sh
task build
```

### Deploy Locally

Once all docker images are built and available locally, we can start the Compose services in detached mode, and then immediately start following the logs:

```sh
task start
task logs
```

When we want to shutdown the setup:

```sh
task down
```

Running docker-compose in detached mode has some tradeoffs.

- Pros
  - Current terminal is not blocked
  - Interrupting the task would stop containers, but not remove them
    - In some cases, it might be pretty annoying because containers like Redis (or Valkey) create anonymous volumes to persist the data storage
- Cons
  - The main downside of this approach is that `docker compose logs` is known to show logs in the wrong order
    - Logs are sorted per-container, not globally

### Access Resources

Once the deployment is successfully complete, you might be interested in one of the three services that are "exposed" to the host machine:

- Shinyproxy: [http://localhost:8080](http://localhost:8080)
- LDAP Manager: [http://localhost:6480](http://localhost:6480)
- Grafana: [http://localhost:3000](http://localhost:3000)

Notice, that we only expose what is absolutely necessary.
Things like Databases, API services, LDAP server are only available to other Docker services via the shared Docker Network.
This is a good security practice that limits the external access into the system.
Moreover, all three exposed applications have authentication mechanisms (Grafana login is disabled for convenience, but can be easily enabled via environment variable).

### Authentication

When the project is launched for the very first time,
the authentication will need to be configured.

To setup OpenLDAP via the Admin UI:

- Visit [http://localhost:6480/setup](http://localhost:6480/setup)
- Enter the admin password, (`admin` is the default)
- Do not change anything, click "Next" button
- Click "Create new account" button
- Complete the form (you may skip email)
  - This is going to be the first user in the system, i.e. *the* admin
  - It is recommended to give them a distinct first and last name, e.g. `super admin`
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
