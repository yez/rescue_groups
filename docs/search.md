## Search

`Animal`, `Organization` and `Event` models have a queryable interface using the `where` method. Multiple arguments may be given to a single `where` statement as a single hash. The `where` method is guaranteed to return an `Array`.

Example:

```ruby
# Case does not matter when comparing attriutes like breed
Animal.where(breed: 'daschund')

# Multiple arguments sent in one hash
Animal.where(eye_color: 'green', declawed: true)
```

All fields can be found for [animal](animal_field.md), [organization](organization.md), and [event](event_field.md).
