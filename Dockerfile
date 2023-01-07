FROM ruby:3.1.2 AS rails-toolbox

RUN apt update && apt install -y \
  nodejs \
  nano \
  rbenv

# Set default working directory as app's root directory.
# opt directory is in the container & it might be diff than regular Ubuntu
# Many people create a directory under root.
#ROOT_DIR='/home/ubuntu'
# Convention: /opt/app_name - to store applications
ENV INSTALL_PATH /opt/rails_see_stuff
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN echo "SHOW directory & contents"
RUN pwd
RUN ls -lah
RUN echo

RUN echo "COPYING Gemfile, Gemfile & launch_app.sh .lock into Docker container from root of AWS EC2 instance."
# COPY Gemfile .
# COPY Gemfile.lock .
# COPY launch_app.sh .
COPY . .
RUN echo
RUN ls -lah
RUN echo

# Install Rails & Bundler in container. They are required for rails commands for the database, etc.
RUN echo "INSTALLING rails 7 & bundler 2.3.22..."
RUN echo "gem: --no-document" > ~/.gemrc
RUN gem install rails -v 7 && gem install bundler -v 2.3.22
RUN bundle install
RUN echo

RUN echo "CURRENT system ruby is:"
RUN ruby -v
RUN echo

RUN echo "SHOW Rails version..."
RUN rails -v
RUN echo
RUN echo "SHOW bundler version..."
RUN bundler -v
RUN echo

RUN echo "SHOW the PATH with gem env: "
RUN gem env
RUN echo "SHOW where gems are installed with the home argument with: gem env home"
RUN gem env home
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
RUN chmod +x launch_app.sh
CMD [ "/bin/bash", "-c", "bash launch_app.sh" ]

# With Docker & Docker Compose, see locally running app at: http://localhost:48017
# Note: Runs in container on port 3000 but I forwarded port to 48017.
