FROM ruby:3.2.2-slim-bookworm

LABEL MAINTAINER Diogo Caetano <diogo@proposito.digital>
# Last update 02/2024

# Install essential Linux packages
RUN apt-get clean
RUN apt-get update
RUN apt-get install -y git-all
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev libnotify-bin xosd-bin nano curl wget unzip gnupg

# Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable
# Chrome Driver list of versions https://googlechromelabs.github.io/chrome-for-testing/
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}') \
    && CHROME_MAJOR=${CHROME_VERSION%%.*} \
    && CHROME_DRIVER_VERSION=$(curl -fsSL "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_MAJOR}") \
    && wget "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_DRIVER_VERSION}/linux64/chromedriver-linux64.zip" \
    && unzip chromedriver-linux64.zip \
    && mv chromedriver-linux64/chromedriver /usr/bin/chromedriver \
    && chown root:root /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm -rf chromedriver-linux64.zip chromedriver-linux64

# install posgtres client
ARG POSTGRESQL_VERSION="16"
ARG DEBIAN_VERSION="bookworm"
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ ${DEBIAN_VERSION}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -qq
RUN apt install -y postgresql-client-${POSTGRESQL_VERSION}

# Install image upload dependences
RUN apt-get install -y imagemagick graphviz file

#certificados openssl
RUN apt-get install -y openssl ca-certificates

# Define where our application will live inside the image
ENV RAILS_ROOT /var/www/myapp
# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids
# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Expose port 3000 to the Docker host, so we can access it, on dokku the nginx map this port
# from the outside.
EXPOSE 80
EXPOSE 7658
EXPOSE 3000

# Possible to run the nano command
ENV TERM xterm
# Allow unicode characters in the console
ENV LANG C.UTF-8

# Set volume path to cache bundler
ENV BUNDLE_PATH /bundle/vendor
# update ruby gem system
RUN gem update --system
# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler
# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# Copy the Rails application into place
COPY . .

# add rails bin folder to path this avoid to use 'bundle exec'
ENV PATH="${RAILS_ROOT}/bin:${PATH}"

RUN echo $PATH

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# CMD [ "config/containers/app_cmd.sh" ]

# Command to acess de container
# docker exec -it rails-base-app-1 /bin/bash