# See Stuff README

This puts a Rails project migrated from Ruby 2.6.1, Rails 5.2.4.3 and SQLite, to these versions and their dependencies in a Docker container that can run on AWS:

- Rails 7.0
- Ruby 3.1.2
- SQLite3
- Puma 5.6

The application is a view-only site. It does NOT use Rails scaffolding, i.e., does NOT include the standard CRUD actions.

## To run the app that is in a Docker container and Deployed on AWS

1. Create an EC2 instance on AWS with an Ubuntu image and at least a t2.micro size.
   
2. Create a security rule for TCP to use port 48017 and use that with the instance.
   
3. Run: `main.sh'
   
4. Go to a browser and see the running app. Use the IP address of the instance and port, e.g., `http://54.190.12.61:48017`


## To locally run the app that is in a Docker container using Docker Compose

1. Clone the repo: `git clone git@github.com:kimlew/rails_see_stuff.git`

2. Change to project directory with: `cd rails_see_stuff`

3. Run: `docker compose up --build`
   
4. Go to the browser address: `<http://localhost:48017/>`


## To locally run the app by running a shell script

1. Run: `git clone git@github.com:kimlew/rails_see_stuff.git`

2. Change to project directory with: `cd rails_see_stuff`

3. Run: `bash init_and_run_app.sh`

4. Go to the browser address: `<http://localhost:3000/>`
