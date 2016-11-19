require 'rest-client'
require 'base64'

class Api::PostmatesController < ApplicationController

  def initialize
    @auth_key = Rails.application.secrets.postmate_key
    @customer_id = Rails.application.secrets.customer_id
  end

  def get_estimate
    dropoff_address = params["drop_off"]
    pickup_address = params["pick_up"]
    response = RestClient::Request.execute({
                method: :post,
                url: 'https://api.postmates.com/v1/customers/'+ "cus_L1UBJKTP5tOgf-" + '/delivery_quotes',
                :headers => { 'Authorization' => "Basic MDkyNDMwZGQtMjU4NC00YTczLWIwYmQtYTExZWYzZjliMjIwOg==" },
                :payload => { :dropoff_address => dropoff_address,
                           :pickup_address => pickup_address}})
    # response = RestClient::Request.execute({
    #             method: :post,
    #             url: 'https://api.postmates.com/v1/customers/'+ "cus_L1UBJKTP5tOgf-" + '/delivery_quotes',
    #             :headers => { 'Authorization' => "Basic MDkyNDMwZGQtMjU4NC00YTczLWIwYmQtYTExZWYzZjliMjIwOg==" },
    #             :payload => { :dropoff_address => dropoff_address,
    #                        :pickup_address => pickup_address}})
    render json: response
  end

  def create_delivery
    begin
      response = RestClient::Request.execute({
                method: :post,
                url: 'https://api.postmates.com/v1/customers/'+ "cus_L1UBJKTP5tOgf-" + '/deliveries',
                :headers => { 'Authorization' => "Basic MDkyNDMwZGQtMjU4NC00YTczLWIwYmQtYTExZWYzZjliMjIwOg==" },
                :payload => deliveries_params})
    rescue => e
      render json: e
    else
      render json: response
    end
  end

  private

  def deliveries_params
    params.permit(
      :manifest,:dropoff_name,:dropoff_phone_number,:dropoff_address,:pickup_name,:pickup_phone_number,:pickup_address
    )
  end
end

# :manifest,:dropoff_name,:dropoff_phone_number,:dropoff_address,:pickup_name,:pickup_phone_number,:pickup_address
