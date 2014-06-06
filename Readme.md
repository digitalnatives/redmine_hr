[![Build Status](https://travis-ci.org/digitalnatives/redmine_hr.svg?branch=master)](https://travis-ci.org/digitalnatives/redmine_hr)

## Installation
`bundle install --gemfile=Gemfile.development`

## Cucumber
`BUNDLE_GEMFILE=Gemfile.development cucumber`

## Deployment
You will need to run the the rake task `build` before redmine is deployed. This task will create the `assets/javascripts/hr.js`, which is the only file needed for the client side.
