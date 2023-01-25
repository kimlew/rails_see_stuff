FROM ruby:3.1.2 AS rails-toolbox

LABEL Description="This image is used to start the See Stuff web app"

RUN apt update && apt install -y \
  nodejs \
  nano \
  rbenv

# Set default working directory as app's root directory.
# opt - many people create this directory in the contaner under root
# Convention: /opt/app_name - place to store applications
# Note: Ubuntu machine has root directory, /home/ubuntu.
ENV INSTALL_PATH /opt/rails_see_stuff
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN echo "SHOW directory & contents"
RUN pwd
RUN ls -lah
RUN echo

# Install Rails & Bundler in container. They are required for rails commands for the database, etc.
RUN echo "INSTALLING rails 7 & bundler 2.3.22..."
RUN echo "gem: --no-document" > ~/.gemrc
RUN gem install rails -v 7 && gem install bundler -v 2.3.22

RUN echo "COPYING all files, includ. Gemfile, Gemfile.lock & launch_app.sh into Docker container from root of AWS EC2 instance."
COPY . .
RUN echo
RUN ls -lah
RUN echo

RUN bundle install
RUN echo

# TEST if container working right by running a shell. Comment out after test
# since only 1 CMD allowed per Dockerfile & need that 1 CMD to run web app.
#CMD ["/bin/sh"]

# RUN echo "RUN app LOCALLY to test if configuration is correct."
# CMD ["rails", "server", "-b", "0.0.0.0"]
# Note: The rails server -b parameter - binds rails to all IPs & listens to
# requests from outside the container. Binding the server to 0.0.0.0 lets you
# view the app with your server's public IP address.
# See running app locally at: http://localhost:3000/

# Start/Run the main process.
RUN echo "LAUNCHING See Stuff"
# Note: /bin/bash is the executable program & already has permissions to execute
# scripts, so no chmod +x needed.
CMD [ "/bin/bash", "-f", "launch_app.sh" ] 

# With Docker & Docker Compose, see locally running app at: http://localhost:48017
# Note: Runs in container on port 3000 but I forwarded port to 48017.
