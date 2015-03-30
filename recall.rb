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

DataMapper.finalize.auto_upgrade!

get '/' do 
	@notes = Event.all :order => :id.desc
	@title = 'Todos los Eventos'
	erb :home
end

post '/' do
	e = Event.new
	e.title = params[:title]
	e.content = params[:content]
	e.date = params [:date_event]
	e.created_at = Time.now
	e.updated_at = Time.now
	e.save
	redirect '/'
end

get '/:id' do
	@note = Event.get params[:id]
	@title = "Editar evento ##{params[:id]}"
	erb :edit
end

put '/:id' do
  e = Event.get params[:id]
  e.title = paramas[:title]
  e.date = paramas[:date_event]
  e.content = params[:content]
  e.updated_at = Time.now
  e.save
  redirect '/'
end
get '/:id/delete' do
  @note = Event.get params[:id]
  @title = "Confirma que quiere eiliminar el evento ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  e = Event.get params[:id]
  e.destroy
  redirect '/'
end

get '/:id/complete' do
  e = Event.get params[:id]
  e.complete = n.complete ? 0 : 1 # flip it
  e.updated_at = Time.now
  e.save
  redirect '/'
end
