# mongoid-versioning ![Build](https://github.com/fullhealthmedical/mongoid-versioning/actions/workflows/build.yml/badge.svg?branch=mongoid6)

**Important:** This gem is an extraction of [Mongoid::Versioning](http://mongoid.github.io/en/mongoid/docs/extras.html#versioning) from the official [mongoid](http://mongoid.org) gem.
Since Mongoid::Versioning was removed in the `4.0.0` release of Mongoid, this gem re-enables the functionality of versioned documents.

**Please submit only bug and security fixes**. Neither I will accept new features nor changes to existing APIs. Please consider forking the project if you want new features to appear! :)

---

Mongoid supports simple versioning through inclusion of the `Mongoid::Versioning` module. Including this module will create a versions embedded relation on the document that it will append to on each save. It will also update the version number on the document, which is an integer.

## Installation

### Mongoid/Ruby compatibility

This fork has additional changes to support the following mongoid/ruby versions:

|                 | branch                                                                            | mongoid-paranoid support | Tested ruby version(s) | Build |
|-----------------|-----------------------------------------------------------------------------------|--------------------------|------------------------|-------|
| mongoid <5      | [master](https://github.com/fullhealthmedical/mongoid-versioning/tree/master)     | Yes                      | 2.5, 2.6               | ![Build](https://github.com/fullhealthmedical/mongoid-versioning/actions/workflows/build.yml/badge.svg?branch=master) |
| mongoid 6       | [mongoid6](https://github.com/fullhealthmedical/mongoid-versioning/tree/mongoid6) | No                       | 2.7                    | ![Build](https://github.com/fullhealthmedical/mongoid-versioning/actions/workflows/build.yml/badge.svg?branch=mongoid6) |
| mongoid >= 7.0 < 7.3.5 | [mongoid7](https://github.com/fullhealthmedical/mongoid-versioning/tree/mongoid7) | No                       | 2.7                    | ![Build](https://github.com/fullhealthmedical/mongoid-versioning/actions/workflows/build.yml/badge.svg?branch=mongoid7) |
| mongoid >= 7.0 < 7.3.5 | [mongoid7](https://github.com/fullhealthmedical/mongoid-versioning/tree/mongoid73) | No                       | 2.7                    | ![Build](https://github.com/fullhealthmedical/mongoid-versioning/actions/workflows/build.yml/badge.svg?branch=mongoid73) |

In your Gemfile:

```ruby
gem 'mongoid-versioning', git: 'https://github.com/fullhealthmedical/mongoid-versioning', branch: 'master'
```

## Usage

```ruby
class Person
  include Mongoid::Document
  include Mongoid::Versioning
end
```

You can also set a `max_versions` setting, and Mongoid will only keep the max most recent versions.

```ruby
class Person
  include Mongoid::Document
  include Mongoid::Versioning

  # keep at most 5 versions of a record
  max_versions 5
end
```

You may skip versioning at any point in time by wrapping the persistence call in a `versionless` block.

```ruby
person.versionless do |doc|
  doc.update_attributes(name: "Theodore")
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

(The MIT license)

Copyright (c) 2009-2013 Durran Jordan, 2013-2015 Mario Uher

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
