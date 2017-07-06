json.extract! user, :id, :first_name, :last_name, :account_type
if user.family_data
    json.extract! user.family_data, :family_size, :family_photo, :family_story, :wish_list
end

if session
  json.session_token session
end
