require "rails_helper"

RSpec.describe "Flights Index Page" do 

  before(:each) do 
    @frontier = Airline.create!(name: "Frontier")
    @delta = Airline.create!(name: "Delta")
    @flight_1 = @frontier.flights.create!(number: "1727", date: "08/03/20", departure_city: "Denver", arrival_city: "Reno")
    @flight_2 = @delta.flights.create!(number: "1749", date: "08/03/20", departure_city: "Boston", arrival_city: "Los Angeles")
    @pass_1 = Passenger.create!(name: "Ricky", age: 24)
    @pass_2 = Passenger.create!(name: "Randy", age: 2)
    @pass_3 = Passenger.create!(name: "Lahey", age: 40)
    @pass_4 = Passenger.create!(name: "Lucy", age: 30)
    @pass_flight_1 = PassengerFlight.create!(flight_id: @flight_1.id, passenger_id: @pass_1.id)
    @pass_flight_2 = PassengerFlight.create!(flight_id: @flight_1.id, passenger_id: @pass_2.id)
    @pass_flight_3 = PassengerFlight.create!(flight_id: @flight_2.id, passenger_id: @pass_3.id)
    @pass_flight_4 = PassengerFlight.create!(flight_id: @flight_2.id, passenger_id: @pass_4.id)

  end

  it "lists all flight numbers" do 
    visit flights_path

    within("#flight-#{@flight_1.id}") do 
      expect(page).to have_content(@flight_1.number)
    end 

    within("#flight-#{@flight_2.id}") do 
      expect(page).to have_content(@flight_2.number)
    end 
  end

  it "has name of airline of the flight next to number" do 
    visit flights_path 

    within("#flight-#{@flight_1.id}") do 
      expect(page).to have_content(@frontier.name)
    end 

    within("#flight-#{@flight_2.id}") do 
      expect(page).to have_content(@delta.name)
    end 
  end

  it "has names of all flights passengers under each flight number" do 
    pass_flight_5 = PassengerFlight.create!(flight_id: @flight_2.id, passenger_id: @pass_1.id)
    visit flights_path 

    within("#flight-#{@flight_1.id}") do
      expect(page).to have_content(@pass_1.name)
      expect(page).to have_content(@pass_2.name)
    end

    within("#flight-#{@flight_2.id}") do
      expect(page).to have_content(@pass_1.name)
      expect(page).to have_content(@pass_3.name)
      expect(page).to have_content(@pass_4.name)
    end
  end

  it "has a button to remove each passenger" do 
    pass_flight_5 = PassengerFlight.create!(flight_id: @flight_2.id, passenger_id: @pass_1.id)
    visit flights_path

    within("#flight-#{@flight_1.id}") do 
      expect(page).to have_content(@pass_1.name)

      click_button "Remove #{@pass_1.name}"

      expect(current_path).to eq("/flights")
      expect(page).to_not have_content(@pass_1.name)
    end 

    within("#flight-#{@flight_2.id}") do 
      expect(page).to have_content(@pass_1.name)
    end
  end
end