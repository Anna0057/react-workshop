class LocationsController < ApplicationController
  respond_to :html, :json

  before_action :set_location

  def suggest
    @locations = scope.first(10).map &:decorate
    respond_with(@locations)
  end

  def show
    @location = @location && @location.decorate
    respond_with(@location)
  end

  private
  def scope
    scope = Location
    scope = scope.name_starts_with(params[:q].split('>').last.strip) if params[:q] && !params[:q].empty?
    scope
  end

  def set_location
    location_id = params[:location_id] || params[:id]
    @location ||= Location.find(location_id) if location_id && !location_id.empty?
  end
end
