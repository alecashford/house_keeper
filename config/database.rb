# Log queries to STDOUT in development
if Sinatra::Application.development?
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

DB_NAME = ENV['PROD_DB_NAME']

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :host     => ENV['DB_HOST'],
  :port     => ENV['DB_PORT'],
  :username => ENV['APP_DB_USERNAME'],
  :password => ENV['APP_DB_PASSWORD'],
  :database => DB_NAME,
  :encoding => 'utf8'
)
