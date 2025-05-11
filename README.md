# Shiny System Design

System design for Shiny developers based around Shinyproxy deployment.

## About the project structure

- Microservices
- Domain boundaries
  - Authentication
  - Shinyproxy
  - Telemetry
  - Metrics
  - Services

Every "domain" is developed in its own folder, and has its own Docker Compose Stack
defined in a corresponding *compose.yml* file.

## Setup and configuration

### Authentication

To setup OpenLDAP via the admin UI:

- Visit [http://localhost:6480/setup](http://localhost:6480/setup)
- Enter the admin password, (`admin` is the default)
- Do not change anything, click "Next" button
- Click "Create new account" button
- Complete the form (you may skip email)
- Once done, click "Finish" button
- Proceed to login
  - By default, login is the combination of first and last names separated with a `-`
- You are now logged in as the admin user
  - You can now add new users and control their group
  - Remember, that the group (either `admins` or `users` will have effect on what the user will see in Shinyproxy!)
- The LDAP configuration is persisted via a docker volume
  - Only one time configuration is required

## Monitoring

### Telemetry
