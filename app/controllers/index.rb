get '/' do
  @raw_total = 0
  if session[:user_id]
    erb :register_house
  end
  erb :index
end

#----------- SESSIONS -----------

get '/logout' do
  session.clear
  redirect '/'
end

post '/sessions' do
  login
end

#----------- USERS -----------

get '/register_house' do
  erb :register_house
end

get '/register-user' do
  erb :register_user
end

post '/create-user' do
  User.create(:first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email],
              :phone => params[:phone], :password_hash => BCrypt::Password.create(params[:password]),
              :house_id => session[:house_id]) #add a feature where, if no house is in sessions, it will
                                               #allow you to put in house code manuall and assign you to that house
  redirect '/'
end

post '/add-user' do
  content_type :json
  User.create(:first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email],
              :phone => params[:phone], :password_hash => BCrypt::Password.create(params[:password]),
              :house_id => session[:house_id])
  "#Here are the params: #{params[:first_name]} #{params[:last_name]}"
end # should be combined with create user, above. Currently only services the ajax popup box

post '/create-house' do
  new_house = House.create(:house_number => params[:house_number], :street => params[:street], :city => params[:city],
                :state => params[:state], :zip_code => params[:zip_code], :country => params[:country])
  new_house.generate_code
  session[:house_id] = new_house.id
  Utility.create(:house_id => session[:house_id], :utility_type => "Rent", :amount => to_cents(params[:rent]), :provider => "")
  erb :register_house
  redirect '/register-user'
end

post '/populate' do
  content_type :json
  util_var = Utility.where(:house_id => session[:house_id], :active => true)
  exp_var = Expenditure.where(:house_id => session[:house_id], :active => true)
  json_obj = []
  util_var.each do |obj|
    json_obj << {utility: {utility_type: obj.utility_type, provider: obj.provider, amount: dollar_format(obj.amount)}}
  end
  exp_var.each do |obj|
    first_name = User.find(obj.user_id).first_name
    json_obj << {utility: {utility_type: obj.note, provider: first_name, amount: dollar_format(obj.amount)}}
  end
  return json_obj.to_json
end

get '/add-utility' do
erb :add_utility
end

post '/create-utility' do
  content_type :json
  p params
  Utility.create(:house_id => session[:house_id], :utility_type => params[:utility_type], :provider => params[:provider],
                 :amount => to_cents(params[:amount]))

  {utility_type: params[:utility_type], provider: params[:provider], amount: dollar_format(to_cents(params[:amount]))}.to_json
end

post '/login' do
  redirect '/'
end

post '/add-expenditure' do
  content_type :json
  new_expense = Expenditure.create(:user_id => session[:user_id], :amount => to_cents(params[:cost]), :note => params[:note], :house_id => session[:house_id])
  name_of_buyer = User.where(:id => new_expense.user_id)[0].first_name
  {first_name: name_of_buyer, note: params[:note], amount: dollar_format(to_cents(params[:cost]))}.to_json
end

post '/call-in' do
  mates = User.where(:house_id => session[:house_id])
  text = "One of your roomates has called in for monthly billing. If you haven't already done so, log on to House Keeper and input any utility bills or expenditures you may be responsible for. Thank you!"
  mates.each do |mate|
    send_message(mate.email, "Calling In Bills For This Month!", text)
  end
end

post '/cash-out' do
  send_cashout_msg
  Utility.where(:active => true, :house_id => session[:house_id]).update_all(:active => false)
  Expenditure.where(:active => true, :house_id => session[:house_id]).update_all(:active => false)
  return "Blank slate"
  redirect '/'
end

post '/make-dollar' do
  content_type :json
  dollars = dollar_format(params[:amount])
  {amount: dollars}.to_json
end

post '/update-splash-values' do

end

post '/sum-total' do
  content_type :json
  {total: sum_total, your_share: your_share}.to_json
end




