require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/appevents.db")

#**********CLASES BBDD****************

class Event
	include DataMapper::Resource
	property :id, Serial
	property :title, Text, :required => true
	property :content, Text, :required => true
	property :date_event, DateTime, :required => true
	property :created_at, DateTime
	property :updated_at, DateTime
end

class Invite
	include DataMapper::Resource
	property :id, Serial
	property :id_event, Text
	property :name_invited, Text
	property :email, Text, :required => true 
	property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!


#***********************INDEX****************************

get '/' do

@title = 'Hola! Este es el proyecto'
erb :index

end

#******************

get '/events' do 
	@events = Event.all :order => :id.desc
	@title = 'Todos los Eventos'
	erb :home
end


get '/create' do
	@title = 'Crear Eventos'
	erb :create
end


post '/create' do
	e = Event.new
	e.title = params[:title]
	e.content = params[:content]
	e.date_event = params[:date_event]
	e.created_at = Time.now
	e.updated_at = Time.now
	e.save
	redirect '/events'
end

#*************************EDIT***************************

get '/events/:id' do
	@event = Event.get params[:id]
	@title = "Editar evento ##{params[:id]}"
	erb :edit
end

put '/events/:id' do
  e = Event.get params[:id]
  e.title = params[:title]
  e.date_event = params[:date_event]
  e.content = params[:content]
  e.updated_at = Time.now
  e.save
  redirect '/events'
end

#********************DELETE***************************

get '/events/:id/delete' do
  @event = Event.get params[:id]
  @title = "Confirma que quiere eiliminar el evento ##{params[:id]}"
  erb :delete
end

delete '/events/:id' do
  e = Event.get params[:id]
  e.destroy
  redirect '/events'
end

#**********************INVITE***********************

get '/events/:id/invite' do
	@title = "Hacer la invitacion a un evento"
	@event = Event.get params[:id]
	@invites = Invite.all(:id_event => @event.id ) 
	erb :invite
end

post '/events/:id/invite' do
	e = Event.get params[:id]
	i = Invite.new
	i.id_event = e.id
	i.email = params[:email]
	i.name_invited = params[:name_invited]
	i.created_at = Time.Now
	i.save
end

put '/events/:id/invite' do
	e = Event.get params[:id]
	i = Invite.new
	i.id_event = e.id
	i.email = params[:email]
	i.name_invited = params[:name_invited]
	i.created_at = Time.now
	i.save
	redirect '/events'

end


