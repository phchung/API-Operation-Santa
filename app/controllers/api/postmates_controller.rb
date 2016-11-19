require 'rest-client'
require 'base64'

class Api::PostmatesController < ApplicationController

  def initialize
    @auth_key = Rails.application.secrets.postmate_key
    @customer_id = Rails.application.secrets.customer_id
  end

  def get_estimate
    response = RestClient::Request.execute({
                method: :post,
                url: 'https://api.postmates.com/v1/customers/'+ "cus_L1UBJKTP5tOgf-" + '/delivery_quotes',
                :headers => { 'Authorization' => "Basic MDkyNDMwZGQtMjU4NC00YTczLWIwYmQtYTExZWYzZjliMjIwOg==" },
                :payload => { :dropoff_address => params["dropoff_address"],
                           :pickup_address => params["pickup_address"]}})
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
                :payload => deliveries_params.concat(parse_number)})
    rescue => e
      render json: e
    else
      render json: response
    end
  end

  def parse_number
    number = {:pickup_phone_number =>
      params[pickup_phone_number].gsub(/[^0-9\s]/i, '').delete(" "),
      :dropoff_phone_number =>
      params[dropoff_phone_number].gsub(/[^0-9\s]/i, '').delete(" ")}
    number
  end

  private

  def deliveries_params
    params.permit(
      :quote_id,:manifest,:dropoff_name,:dropoff_phone_number,:dropoff_address,:pickup_name,:pickup_phone_number,:pickup_address
    )
  end
end
