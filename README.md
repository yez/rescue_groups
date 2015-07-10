## Rescue Groups API

Wrapper for RescueGroups.org API

![Build Status](https://travis-ci.org/yez/rescue_groups.svg?branch=master)

# Purpose

Ruby wrapper for the [HTTP RescueGroups API](https://userguide.rescuegroups.org/display/APIDG/HTTP+API). This is a read only gem that provides basic functionality needed to read from RescueGroups.

# Installation

In your project's Gemfile:

`gem 'rescue_groups'`

In a Rails application, all files will be included by default.

In other Ruby applications, call `require 'rescue_groups'` where RescueGroups is needed.

# Configuration

An API key is required to use the RescueGroups API. An `ENV` variable named `'RESCUE_GROUPS_API_KEY'` is automatically accessed on initialization.

Otherwise, add the following block to an initializer in your application:

```ruby
RescueGroups.configuration do |config|
  config.apikey = 'your api key'
end
```

# Querying

Two methods, `find` and `where`, are used to query about three resources: `Animal`, `Organization`, and `Event`.

### `find`

The find method accepts one to multiple ids and returns one or many results, respectively.

**One ID**

```ruby
Animal.find(1)
#=> <Animal id: 1, name: 'Fluffy' ...>
```

**Multiple IDs**

```ruby
Animal.find([20, 30, 40])
#=> [<Animal id: 20, name: 'Mittens' ...>, <Animal id: 30, name: 'Mr. Doom' ...>, <Animal id: 40, name: 'CatDog' ...>]
```

**404 Response**

If the object(s) is not found, an exception is raised `"Unable to find Animal with id: -1"

### `where`

The where method accepts a hash of attributes and finds animals that match all the criteria.

**One attribute**

```ruby
Organization.where(name: 'Pets-R-Us')
# => <Organization id: 1, name: 'Pets-R-Us' ...>
```

**Multiple attributes**

```ruby
Organization.where(name: 'Big Bobs Pets', city: 'Kansas City')
# => <Organization id: 42, name: 'Big Bobs Pets', city: 'Kansas City' ...>
```

# Test Mocks

For testing, each model has a corresponding mock class. Mocked classes are available by default.

### `find`

Returns a single object as if it was from a successful `find` method call.

```ruby
RescueGroups::AnimalMock.find
#=> <Animal id: 123, name: 'fluffy' ...>
```

Use this method while testing in place of writing your own custom factories/stubbed versions of RescueGroups objects.

```ruby
describe SomeTestClass do
  let(:animal) { RescueGroups::AnimalMock.find }

  specify do
    # test method body
  end
end
```

### `find_not_found`

To emulate an error during a find call for testing, the `find_not_found` method will raise the same error as a typical `find` method.

```ruby
RescueGroups::AnimalMock.find_not_found
# => Unable to find Animal
```

### `where`

Returns an array containing a single object as if it was from a successful `where` method call.

```ruby
RescueGroups::AnimalMock.where
#=> [<Animal id: 123, name: 'fluffy' ...>]
```

Use this method while testing in place of writing your own custom factories/stubbed versions of RescueGroups objects.

```ruby
describe SomeTestClass do
  let(:animal_response) { RescueGroups::AnimalMock.where }

  specify do
    # test method body
  end
end
```

### `where_not_found`

The `where_not_found` method emulates a `where` method that returns no results, and returns an empty array.

```ruby
RescueGroups::Animal.where_not_found
#=> []
```
