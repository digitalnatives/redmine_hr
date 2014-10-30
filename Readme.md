# HR Management Application. 
[![Build Status](https://travis-ci.org/digitalnatives/redmine_hr.svg?branch=master)](https://travis-ci.org/digitalnatives/redmine_hr)

This repository houses an administration application (currently as a redmine plugin but separating it is under way).

Features:
  * Manage Employee Profiles
  * Manage Holiday Requests & flow (approve, reject...)
  * Manage childrens of the employees
  * Calculate holidays for employees

## Architecture
The backend is a simple **Rails** application (currenty located in [app.rb](app.rb)), that provides an API for the frontend application.

Te frontend is a **Fron** application that renders **Haml** templates. 

## Installation
For development you need to use the `Gemfile.development` gem.

`bundle install --gemfile=Gemfile.development`

## Testing
You can run frontend tests with 

`bundle exec rake test`

You can run rspec tests with

`bundle exec rake spec --rcolor`

## Integration Tests
You can run the integration tests with this:

`BUNDLE_GEMFILE=Gemfile.development cucumber`

## Deployment
You will need to run the the rake task `build` before redmine is deployed. This task will create the `assets/javascripts/hr.js`, which is the only file needed for the client side.
