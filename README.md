# Sweater Weather

This application is the final project of the [Turing School of Software and Design's](https://turing.io/) [Module 3](https://backend.turing.io/module3/). It is an API built in Ruby on Rails which authenticates users and aggregates and presents data from multiple 3rd party APIs. The application uses as PostgresQL database.

## Versions
- Rails 5.1.7
- Ruby 2.5.3

## Setup
1. Clone this repository and run the following commands:
  1. `bundle`
  1. `rails db:create` and `rails db:migrate` to create the database
  1. `rails s` to start your local server
  1. The application endpoints will now be available on http://localhost:3000

## Endpoints

GET Forecast: /api/v1/forecast?location={string}
  - returns local weather forecast from [OpenWeather](https://openweathermap.org/api) for the specified location
  
GET Background Image: /api/v1/backgrounds?location={string}
  - returns background image from Google for the specified location
 
POST Create User: /api/v1/users
  - creates a user in the database
  - requires email, password, and password_confirmation sent in request body
  
 POST Login User: /api/v1/sessions
   - created user logs into the application
   - requires email and password sent in request body
 
 POST Create Road Trip: /api/v1/road_trip
   - creates "Road Trip" from origin to destination, estimates travel time, and returns forecast at scheduled arrival time
   - requires origin, destination, and api_key (returned at user login) in body of request
  
