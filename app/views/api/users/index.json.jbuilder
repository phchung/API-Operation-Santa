# json.array! @users do |user|
#   json.extract! user,:id, :username,:first_name,:last_name,:account_type,:address
#   if user.family
#     json.extract! user.family, :family_size,:family_photo,:family_story
#   end
# end

# @users.each do |event|
#   json.set! event.id do
#     json.extract! event, :title,:location,:category,:description,:picture_url,
#     :price,:start_date ,:end_date,:start_time,:end_time,:user_id,:id,:lat,:lng
#   end
# end

@users.each do |user|
    json.set! user.id do
      json.extract! user,:id, :username,:first_name,:last_name,:account_type,:address,:phone_number
    if user.family_data
      json.extract! user.family_data, :family_size,:family_photo,:family_story
    end
  end
end
