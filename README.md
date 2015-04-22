# Silence

Welcome to my new gem which I use to writing functional tests. I named it "silence" because I like silence :)

## Installation

Install gem:

    $ gem install 'silence'


## Usage

Generate new project:

    $ silence new project_name

During installation generator makes:

* generate project structure
* install all required libraries
* setup ruby environment(create .ruby-gemset and .ruby-version)

Then run "cucumber" in project path
    
    cucumber

## Running options:

All available options we can see in cucumber.yml and all running options should be described there.

## Project structure:

```
├── config
│   ├── browser_profiles
│   └── data
├── features
│   ├── pages
│   │   ├── widgets
│   │   │   └── some_widgets.rb
│   │   └── some_page.rb
│   ├── step_definitions
│   │   └── some_steps.feature
│   ├── support
│   └── some_feature.feature
├── reports
├── silence
│   └── cli
└── cucumber.yml
```

to be continued ...

