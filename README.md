# See Stuff README

This puts a Rails project migrated from Ruby 2.6.1, Rails 5.2.4.3 and SQLite, to these versions and their dependencies in a Docker container that can run on AWS:

- Rails 7.0
- Ruby 3.1.2
- SQLite3
- Puma 5.6

The application is a view-only site. It does NOT use Rails scaffolding, i.e., does NOT include the standard CRUD actions.

## To run the application in Docker on AWS

1. Run: `main.sh'
   
2. Go to a browser and see the running app at the IP address, e.g., `<https://54.190.12.61/>`

## To run the application in Docker locally:

1. Run: `git clone git@github.com:kimlew/rails_see_stuff.git`

2. Change to project directory with: `cd rails_see_stuff`

3. Run: `docker run`     Before was: `bash init_and_run_app.sh`

4. Go to the browser address: `<http://localhost:3000/>`
