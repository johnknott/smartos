[![Build Status](https://api.shippable.com/projects/544442a6b904a4b21567add5/badge?branchName=master)](https://app.shippable.com/projects/544442a6b904a4b21567add5/builds/latest)

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

Assumes you have passwordless authentication setup to root@your-global-zone.
If you haven't yet, you can do this with (`ssh-copy-id root@your-global-zone`)

First connect to your global zone with ( connect ) then inside the block run commands like imgadm, vmadm, and svcadm.

    SmartOS::GlobalZone.connect('your-global-zone.com') do
      imgadm.add_source 'http://datasets.at/'
      puts imgadm.sources
    end


## Contributing

1. Fork it ( https://github.com/[my-github-username]/smartos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
