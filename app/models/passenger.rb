class Passenger < ApplicationRecord
  has_many :passenger_flights, dependent: :destroy 
  has_many :flights, through: :passenger_flights


  def adult? 
    age >= 18 
  end
  
end