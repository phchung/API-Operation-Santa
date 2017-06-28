json.extract! user, :id, :email, :username, :first_name, :last_name, :account_type, :address, :phone_number
if user.family_data
    json.extract! user.family_data, :family_size,:family_photo,:family_story
end

if session
  json.session session
end
