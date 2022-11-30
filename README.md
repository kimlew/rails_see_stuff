# See Stuff README

This migrates a previous Rails project that used Ruby 2.6.1, Rails 5.2.4.3 and SQLite, to these versions and their dependencies:

- Rails 7.0
- Ruby 3.1.2
- SQLite3
- Puma 5.6

The application is a view-only site. It does NOT use Rails scaffolding, i.e., does NOT include the standard CRUD actions.

## To run the application locally:

1. Run: `git clone git@github.com:kimlew/rails_see_stuff.git`

2. Change to project directory with: `cd rails_see_stuff`

3. Create an .env file with the environment variables for the ports to use:

  ```
   PORT_ASSIGNED_ON_HOST_FOR_WEB_APP=48017
   PORT_RAILS_WEB_SERVER_DEFAULT=3000
  ```

4. Run: `docker compose up --build`

5. Go to the browser address: `<http://localhost:3000/>`
