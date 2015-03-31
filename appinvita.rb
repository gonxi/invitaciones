require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/appevents.db")

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
	property :email, Text, :required => true 
	property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!


get '/' do 
	@events = Event.all :order => :id.desc
	@title = 'Todos los Eventos'
	erb :home
end

post '/' do
	e = Event.new
	e.title = params[:title]
	e.content = params[:content]
	e.date_event = params[:date_event]
	e.created_at = Time.now
	e.updated_at = Time.now
	e.save
	redirect '/'
end

get '/:id' do
	@event = Event.get params[:id]
	@title = "Editar evento ##{params[:id]}"
	erb :edit
end

put '/:id' do
  e = Event.get params[:id]
  e.title = params[:title]
  e.date_event = params[:date_event]
  e.content = params[:content]
  e.updated_at = Time.now
  e.save
  redirect '/'
end

get '/:id/delete' do
  @event = Event.get params[:id]
  @title = "Confirma que quiere eiliminar el evento ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  e = Event.get params[:id]
  e.destroy
  redirect '/'
end

get '/:id/invite' do
	@title = "HAcer la invitacion a un evento"
	@event = Event.get params[:id]
	erb :invite
end

post '/:id/invite' do
	i = Invite.new
	i.id_event = params[:id_event]
	i.email = params[:email]
	i.created_at = Time.Now
end


