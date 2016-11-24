require 'rest-client'
require 'base64'

class Api::PostmatesController < ApplicationController

  def initialize
    @auth_key = Rails.application.secrets.postmate_key
    @customer_id = Rails.application.secrets.customer_id
  end

  def get_estimate
    begin
      response = RestClient::Request.execute({
                method: :post,
                url: 'https://api.postmates.com/v1/customers/'+ "cus_L1UBJKTP5tOgf-" + '/delivery_quotes',
                :headers => { 'Authorization' => "Basic MjBiNDY1MWUtODM1ZC00NmIxLWIwY2YtZmEwZjU2YmU1OTA1Og==" },
                :payload => { :dropoff_address => params["dropoff_address"],
                           :pickup_address => params["pickup_address"]}})
    rescue => e
      render json: e.http_body, status: 401
    else
      render json: response
    end
  end

  def create_delivery
    begin
      response = RestClient::Request.execute({
                method: :post,
                url: 'https://api.postmates.com/v1/customers/'+ "cus_L1UBJKTP5tOgf-" + '/deliveries',
                :headers => { 'Authorization' => "Basic MjBiNDY1MWUtODM1ZC00NmIxLWIwY2YtZmEwZjU2YmU1OTA1Og==" },
                :payload => deliveries_params.merge(parse_number)})
    rescue => e
      render json: e.http_body, status: 401
    else
      render json: response.body
    end
  end

  def parse_number
    number = {:pickup_phone_number =>
      params[:pickup_phone_number].gsub(/[^0-9\s]/i, '').delete(" "),
      :dropoff_phone_number =>
      params[:dropoff_phone_number].gsub(/[^0-9\s]/i, '').delete(" ")}
    number
  end

  private

  def deliveries_params
    params.permit(
      :quote_id,:manifest,:dropoff_name,:dropoff_phone_number,:dropoff_address,:pickup_name,:pickup_phone_number,:pickup_address,
      :robo_delivered,:robo_dropoff,:robo_pickup_complete,:robo_pickup
    )
  end
end
# save delivry history
# put call for updating user info
# deleter user
