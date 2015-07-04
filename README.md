## Rescue Groups API

Wrapper for RescueGroups.org API

![Build Status](https://travis-ci.org/yez/rescuegroups.svg?branch=master)

## Resources

1. Animal
  - belongs to an organization
  - methods:
    - `find`
      Find a single animal by primary key (id)

      ```ruby
        Animal.find(1)
        #=> <Animal id: 1, name: 'Whiskers'>
      ```
    - `where`
      Search for an animal by specific [fields](docs/animal_field.md)

      ```ruby
        Animal.where(breed: 'daschund')
        #=> [<Animal id: 4, breed: 'Daschund'>, <Animal id: 7, breed: 'Daschund'>]
      ```

2. Organization
  - has many animals
  - has many events
  - methods:
    - `find`
      Find a single organization by primary key (id)

      ```ruby
        Organization.find(1)
        #=> <Organization id: 1, name: 'Happy Animals of Chicago'>
      ```
    - `where`
      Search for an organization by specific [fields](docs/organization_field.md)

      ```ruby
        Organization.where(city_name: 'Chicago')
        #=> [<Organization id: 4, city_name: 'Chicago'>, <Organization id: 7, city_name: 'Chicago'>]
      ```
3. Event
  - belongs to an organization
  - methods:
    - `find`
      Find a single event by primary key (id)

      ```ruby
        Event.find(1)
        #=> <Event id: 1, name: 'Black cat event'>
      ```
    - `where`
      Search for an event by specific [fields](docs/event_field.md)

      ```ruby
        Event.where(event_name: 'Awesome Puppies')
        #=> [<Event id: 4, event_name: 'Awesome Puppies'>]
      ```

