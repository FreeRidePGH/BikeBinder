# BikeBinder for Free Ride

## Objective

Reproduce all functionality that exists with the current paper bike binder and departed bikes binder system.


## Getting up and running for development

### After the first clone

Take the following actions to get a cloned/pulled version to run locally for development

* Rename the database config file (remove ".sample")
* Install gems
* Initialize and populate the database 

        cp config/database.yml.sample config/database.yml
        bundle install
        rake db:populate


### After each time you pull updates

* Install missing (or out of date) gems
* Reinitialize and repopulate the database (see seeding approaches for details)

        bundle install
        rake db:populate

## Running tests

* Create the test database
* Start the autotest

        rake db:test_setup
        bundle exec guard

## Documentation Tasks

* Generating ERD images using railroady (http://railroady.prestonlee.com/)

        rake diagram:all

* Diagram state machines

        rake state_machine:draw FILE=bike.rb CLASS=Bike


--------------------------------------------


## Approach to seeding the application

### Seeding tasks

* Non-destructively seed what is necessary to get the application running
 * Can be used to update a running application to additions made to the database

        rake db:seed

* Destructive seeding that resets the database structure and loads demo data
 * Existing data will be lost when the database is reset
 * Guarantees the database has the proper structure (good for development, especially if the strucuture is changing during development)

        rake db:populate


(See also http://guides.rubyonrails.org/testing.html#preparing-your-application-for-testing)


--------------------------------------------

## Feature Scope

In order to get a functional prototype running, we need to adhere to a limit scope. We can add features later. If a feature is desired, but not in scope, it can be added to the outside scope list.

### Scope for Milestone 1

* Bike info sheet: Location, Characteristic (Size, mfg, model, color), Notes, Value, Departure & Arrival Dates
* Youth projects sheet: Program name, State (Active/inactive)
* Bike location tracking: Hook associations to bikes

### Complete Features

* Bike info sheet: Location, Some characteristic, Notes, Departure Dates
* Youth projects sheet: Program name, State (Active/inactive), Inspection
* Bike location tracking: Hook associations to bikes
* Bike state
* Safety inspection
* Project progress
* Youth Project: repair log
* Hook: hook lookup

### Remaining features

* Bike info sheet: Characteristic (Size, mfg, model, color), Value, Arrival Date


### Features for future milestones

* User permissions
* Searching & filtering: bikes, hooks, projects
* Bike demographics (replacing hand-typed characteristics with suggestions or other databased backed data entry)


## UI Considerations
While we do not have an official guideline for the UI, I want feedback and suggestions to go here. I will start listing ideas and notes I have about what will keep our interface uncluttered and what will make it intuitive and easy to use.

### UI Todos
- standardize visual elements to represent different interactions with the bike binder.
eg, a blue underline link represents a Navigational action such as going to the Bikes index page.
- rounded buttons represent actions that have to to with creating and editing data 
	  eg, The Submit Note, Create New Bike buttons represent instantiating new comment or bike objects
- use icons effectively. We want them to help guide the user experience and not act only as eye candy.
     eg, a blue, underlined anchor may represent an action that manipulates data, so an icon can cue the user of the extra option. See one in use on the single bike overview page.
- sensible color scheme. Bootstrap is too minimalist. 


### Future inspirations
- visual diagrams/photos demonstrating bike measurement jargon?
- display the bike color when rendering a bike view
- bike/freeride branding elements? bike with wings logo faded in background of header on certain pages?

--------------------------------------------

## Mobile Strategy

### Routing and controllers

* The existing routes and controllers will provide mobile functionality in addition to standard functionality
* Mobile-only urls will not be used

### Content for mobile devices

* Users will explicitly indicate if they want to use the mobile version 

### Detecting mobile users

* Screen size will be the criteria for detecting mobile
* When mobile is detected, the usr will be given the suggestion to use the mobile version
* A user's preference will be stored in the session

### Unsupported Features

* Unsupported javascript and client-dependent features should fall-back to more standard alternatives.
* Some mobile devices will rely on the fall back features, but others may not need to fall-back


--------------------------------------------

# Project Milestones

## Milestone 1: Youth project implementation to be fully functional

* All of the necessary features and interactions to be able to successfully user the application for youth  projects.

## Milestone 2: Searching/Sorting and bike entry UI

* UI elements to search the site; lookup of bikes & hooks; browse for bikes based on parameters
* Ability to sort filter and get basic reports for bikes and projects;
* Bike demographic data implemented to assist with searching/sorting/filtering
* Intuitive (and instructional) interface for entering new bikes

## Milestone 3: All project types implemented, fully functional and documented

* Youth, Earn-a-bike, Fix-for-sale, Scrap, As-is purchases
* Inspections customized for each project
* Role based authorization for each project type as needed
 * Help pages and documentation to guide users on how to interact with the application

## Milestone 4: User roles and authorization, deployment and support infrastructure

* Mechanism implemented to provide user roles
* Locks in place to require different role based authorization
 * Roles and authorization to allow application to go live without risk to data being corrupt
* Site is live and in-use
* Infrastructure support for: Back-ups and restore; Monitoring & notifying system status; Admin functionality to fix problems/take care of unexpected issues

## Milestone 5: Traceability and reporting

* Record and display history of edits, projects, etc.
* Reporting of bike and project statistics
 * Export of data via XML, CSV or EXCEL


# Copyright

(c) 2012 Free Ride Bicycle Project, See license for details





