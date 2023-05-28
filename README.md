# Rails API (User Signup, Login, Logout) Feature

### Step 1: Generate the User model
In your Rails application directory, open a terminal and run the following command to generate the User model:

``` rails generate model User name:string email:string password_digest:string ```

This will create a User model with the necessary attributes for user authentication.

### Step 2: Set up the database
Run the following command to create the corresponding database table:

``` rails db:migrate ```

### Step 3: Add necessary gems
Open your Gemfile and add the following gems:

```
gem 'bcrypt'
gem 'jwt'
```

Then run bundle install to install the gems.

### Step 4: Implement user authentication
Open the `app/models/user.rb` file and add the following code:

```
class User < ApplicationRecord
  has_secure_password
end
```

This will use the bcrypt gem to securely store passwords.

### Step 5: Create user registration
Create a new file `app/controllers/users_controller.rb` and add the following code:

```
class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
```

### Step 6: Create user login
Add the following code to the `app/controllers/sessions_controller.rb` file:

```
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, 'your_secret_key')
  end
end
```

### Step 7: Create user logout
Add the following code to the `app/controllers/sessions_controller.rb` file:

```
class SessionsController < ApplicationController
  # Existing code...

  def destroy
    # Any additional logout logic you may have (e.g., invalidating tokens)
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
```

### Step 8: Define routes
Open the `config/routes.rb` file and add the following routes:

```
Rails.application.routes.draw do
  resources :users, only: [:create]
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
```

### Step 9: Test the API
You can now test the API endpoints using a tool like cURL or Postman. Here are some example requests:

User signup: `POST /users`

Request body: 
```
{ 
    "name": "John Doe", 
    "email": "john@example.com", 
    "password": "password123" 
}
```
User login: `POST /login`

Request body: 
```
{ "email": "john@example.com", "password": "password123" }
```
Response: 
```{ "token": "your_token_value" }```
User logout: DELETE /logout

Make sure to include the token in the request headers for authentication.
Remember to replace 'your_secret_key' in the encode_token method with a secure secret key of your choice.

