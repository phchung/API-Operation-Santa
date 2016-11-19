json.extract! user, :id, :username, :first_name, :last_name, :account_type, :address,:phone_number
if user.family
    json.extract! user.family, :family_size,:family_photo,:family_story
end
