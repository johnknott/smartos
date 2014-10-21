[![Build Status](https://api.shippable.com/projects/544442a6b904a4b21567add5/badge?branchName=master)](https://app.shippable.com/projects/544442a6b904a4b21567add5/builds/latest)
[![Code Climate](https://codeclimate.com/github/johnknott/smartos/badges/gpa.svg)](https://codeclimate.com/github/johnknott/smartos)
[![Test Coverage](https://codeclimate.com/github/johnknott/smartos/badges/coverage.svg)](https://codeclimate.com/github/johnknott/smartos)

# Smartos

* A small library to help manage a SmartOS Global Zone remotely using Ruby.
* Doesn't require anything to be installed in the Global Zone.

## Installation 

Add this line to your application's Gemfile:

```ruby
gem 'smartos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smartos

## Usage

Assumes you have passwordless authentication setup to root@your-global-zone.com.
If you haven't yet, you can do this with (`ssh-copy-id root@your-global-zone.com`)

First connect to your global zone with `connect` then inside the block run commands like imgadm, vmadm, and svcadm using the usual syntax.

The library inspects the remote SmartOS system and dynamically defines helper methods to execute all binaries in the PATH.

Bang and non-bang methods are created. Bang methods raise an exception on a non-zero exit code and return the result which is parsed if possible, for example into JSON, boolean values, or arrays. This version is more amenable to method-chaining.

Non-bang methods do not throw exceptions but return more information - exitcode, exitsignal, stdout, and stderr. Calling the methods this way is more work but gives you more flexibility.

```ruby
SmartOS::GlobalZone.connect('your-global-zone.com') do

  # Add a dataset source
  imgadm! "sources -a 'http://datasets.at/'"
  # Remove a dataset source
  imgadm! "sources -d 'https://images.joyent.com'"
  # Update currently installed datasets if needed
  imgadm! "update"

  # Bring back the sources and loop through them
  # The JSON is automatically parsed
  imgadm!("sources -j").each do |source_url|
    puts source_url
  end

  # Get an array of available images and map return an array of names
  imgadm!("avail -j").map{|i| i['manifest']['name']}
  # => ["postgresql","steelapp-developer","jenkins", "neo4j","couchdb" ...]

  # Create a VM as defined in the manifest
  vmadm! "create -f /tmp/machine.json"

  # Run an aribtrary command. Result is mapped to boolean.
  svcprop '-c -p general/enabled system/cron:default'
  # => true
end
```


## Contributing

1. Fork it ( https://github.com/johnknott/smartos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
