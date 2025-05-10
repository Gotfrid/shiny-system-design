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

The app crashes when changing value in select input with the following error:

```sh
2025-05-10 17:15:39 Warning: Error in : No method asJSON S3 class: name
2025-05-10 17:15:39   64: base::stop
2025-05-10 17:15:39   63: stop
2025-05-10 17:15:39   62: .local
2025-05-10 17:15:39   61: FUN
2025-05-10 17:15:39   59: vapply
2025-05-10 17:15:39   58: .local
2025-05-10 17:15:39   57: asJSON
2025-05-10 17:15:39   55: jsonlite::toJSON
2025-05-10 17:15:39   54: private$insert_checks
2025-05-10 17:15:39   53: self$data_storage$insert
2025-05-10 17:15:39   52: private$log_generic
2025-05-10 17:15:39   51: private$.log_event
2025-05-10 17:15:39   50: self$log_input_manual
2025-05-10 17:15:39   49: ::
2025-05-10 17:15:39 shiny
2025-05-10 17:15:39 observe
2025-05-10 17:15:39   48: <observer>
2025-05-10 17:15:39    1: shiny::runApp
```
