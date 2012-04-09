# BikeBinder for Free Ride

## Getting up and running

Take the following actions to get a cloned/pulled version to run locally

* rename "config/database.yml.sample" do "config/database.yml"
* run "rake db:populate"

## Objective

Reproduce all functionality that exists with the current paper binder system.

## Scope

In order to get a functional prototype running, we need to adhere to a limit scope. We can add features later. If a feature is desired, but not in scope, it can be added to the outside scope list.

### Within Scope

* Bike info sheet	
 * Location
 * Characteristics
  * Size, mfg, model, color
 * Notes
 * Value
 * Departure & Arrival Dates
* Youth projects sheet
 * Program name
 * State (Active/inactive)
* Bike location tracking
 * Hook associations to bikes

### Outside of scope

* (Associatding projects and bikes)
* Bike demographics (replacing hand-typed characteristics with suggestions or other databased backed data entry)
* Bike state
* Safety inspection
* Project progress






