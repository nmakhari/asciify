class ApplicationController < ActionController::Base
  # allows access to pagy backend in all controllers (uploads and tags)
  include Pagy::Backend
  protect_from_forgery with: :exception
end
