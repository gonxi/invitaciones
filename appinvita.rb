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


#***********************INSERT*****************************

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

#*************************EDIT***************************

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

#********************DELETE***************************

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

#**********************INVITE***********************

get '/:id/invite' do
	@title = "Hacer la invitacion a un evento"
	@event = Event.get params[:id]
	@invites = Invite.all(:id_event => @event.id) 
	erb :invite
end

post '/:id/invite' do
	e = Event.get params[:id]
	i = Invite.new
	i.id_event = e.id
	i.email = params[:email]
	i.name_invited = params[:name_invited]
	i.created_at = Time.Now
	i.save
	redirect '/'
end

put '/:id/invite' do
	e = Event.get params[:id]
	i = Invite.new
	i.id_event = e.id
	i.email = params[:email]
	i.name_invited = params[:name_invited]
	i.created_at = Time.now
	i.save
	redirect '/'
end


