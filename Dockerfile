# pull official base image
FROM ruby:2.0.0

WORKDIR /app

# Copy project
COPY . .

# install dependencies
RUN bundle install

EXPOSE 8002/tcp

# Set deployment env arg
ENV DEPLOYMENT_ENVIRONMENT=development

ENTRYPOINT ["sh", "/app/entrypoint.sh"]
