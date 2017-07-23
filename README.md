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

# Searching

Two methods, `find` and `where`, are used to request three resources: `Animal`, `Organization`, and `Event`.

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

The where method accepts a hash of attributes and finds animals that match all the criteria. If the returned list of objects is less than the count found by the server, a configuration variable can be added to make additional requests are automatically made with the same search criteria until all results returned.

To enable this feature, set the config in an initializer like:

```ruby
RescueGroups.configuration do |config|
  config.load_all_results = true
end
```

A full set of fields are defined for [`Animals`](docs/animal_field.md), [`Organizations`](docs/organization_field.md), and [`Events`](docs/event_field.md)

**One attribute**

```ruby
Organization.where(name: 'Pets-R-Us')
# => [<Organization id: 1, name: 'Pets-R-Us' ...>]
```

To search multiple values on the same attribute, use an array:

```ruby
Animal.where(color: ['black', 'brown'])
# => [<Animal id: 1, color: 'black' ..>, <Animal id: 5, color: 'brown' ..>]
```

**Multiple attributes**

```ruby
Organization.where(name: 'Big Bobs Pets', city: 'Kansas City')
# => [<Organization id: 42, name: 'Big Bobs Pets', city: 'Kansas City' ...>]
```

**Complex attributes**

For more sophisticated searches, the following attributes are provided:

* equal
* not_equal
* less_than
* less_than_or_equal
* greater_than
* greater_than_or_equal
* contains
* not_contain
* blank
* not_blank

These attributes may be used in addition to others in a single `where` call or alone

```ruby
Animal.where(general_age: { less_than: 5 })
# => [<Animal id: 1, age: 2 ..>, <Animal id: 3, age: 1 ..>]

Organization.where(name: { contains: 'shelter'}, location: 90210)
# => [<Organization id: 1, name: 'Big Animal Shelter', location: 90210 ...>, <Organization id: 2, name: 'Small Animal Shelter', location: 90210 ...>,]
```

**No results**

```ruby
Organization.where(name: 'Bad Dogs R Us')
# => []
```
# Relationships

`Animals`, `Organizations`, and `Events` have relationships to one another. `Animals` have a single associated `Organization`, as do `Events`. `Organizations` have 1 or many `Events` and `Animals`.

Calling a relationship that does not exist in memory will automatically fetch the associated object.

```ruby
organization = Organization.find(1)
# => <Organization id: 1, name: 'Pets', city: 'Dallas' ...>

# This will issue a remote call that is equivalent to Animal.where(organization_id: 1)
organization.animals
# => [<Animal id: 1, organization_id: 1 ...>, <Animal id: 2, organization_id: 1 ...>, ...]
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

## Pictures

`Animals` have many `Pictures`

A Picture exposes two methods: `url` and `url_thumb`

Each of these methods accepts an option keyword parameter `secure:`. This param returns a secure url (https) if passed. It it is ommitted, a default http url is returned.

### Default

```ruby
animal = Animal.find(1)
animal.pictures.first.url
#=> "http://image.to.my.animal/1234"
```

### Secure

```ruby
animal = Animal.find(1)
animal.pictures.first.url(secure: true)
#=> "https://secure.image.to.my.animal/1234"
```

#### Contributing

Please feel free to submit pull requests to address issues that you may find with this software. One commit per pull request is preferred please and thank you.
